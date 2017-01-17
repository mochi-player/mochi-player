#include "mpv.h"

#include <stdexcept>
#include <clocale>

#include <QObject>
#include <QOpenGLContext>
#include <QOpenGLFramebufferObject>
#include <QQuickWindow>

static void wakeup(void *ctx) {
  QMetaObject::invokeMethod((MpvObject*)ctx, "onMpvEvents",
                            Qt::QueuedConnection);
}

static QString rtrim(QString str) {
  while(!str.isEmpty() && str[str.length()-1].isSpace())
    str.chop(1);
  return str;
}

class MpvRenderer : public QQuickFramebufferObject::Renderer {
  static void *get_proc_address(void *ctx, const char *name) {
    (void)ctx;
    QOpenGLContext *glctx = QOpenGLContext::currentContext();
    if (!glctx)
      return NULL;
    return (void *)glctx->getProcAddress(QByteArray(name));
  }

  mpv::qt::Handle mpv;
  QQuickWindow *window;
  mpv_opengl_cb_context *mpv_gl;
public:
  MpvRenderer(const MpvObject *obj)
    : mpv(obj->mpv),
      window(obj->window()),
      mpv_gl(obj->mpv_gl) {
    int r = mpv_opengl_cb_init_gl(mpv_gl, NULL, get_proc_address, NULL);
    if (r < 0)
      throw std::runtime_error("could not initialize OpenGL");
  }

  virtual ~MpvRenderer() {
    // Until this call is done, we need to make sure the player remains
    // alive. This is done implicitly with the mpv::qt::Handle instance
    // in this class.
    mpv_opengl_cb_uninit_gl(mpv_gl);
  }

  void render() {
    QOpenGLFramebufferObject *fbo = framebufferObject();
    window->resetOpenGLState();
    mpv_opengl_cb_draw(mpv_gl, fbo->handle(), fbo->width(), fbo->height());
    window->resetOpenGLState();
  }
};

MpvObject::MpvObject(QQuickItem * parent)
  : QQuickFramebufferObject(parent), mpv_gl(0), playState(Idle) {
  // Qt sets the locale in the QGuiApplication constructor, but libmpv
  // requires the LC_NUMERIC category to be set to "C", so change it back.
  std::setlocale(LC_NUMERIC, "C");

  mpv = mpv::qt::Handle::FromRawHandle(mpv_create());
  if (!mpv)
    throw std::runtime_error("could not create mpv context");

  if (mpv_initialize(mpv) < 0)
    throw std::runtime_error("could not initialize mpv context");

  // Make use of the MPV_SUB_API_OPENGL_CB API.
  mpv::qt::set_property(mpv, "vo", "opengl-cb");
  mpv::qt::set_property(mpv, "terminal", false);

  // Prepare our event callbacks
  setEngineEventCallback(MPV_EVENT_PROPERTY_CHANGE, [=](mpv_event *event) {
    propertyChange(static_cast<mpv_event_property*>(event->data));
  });
  setEngineEventCallback(MPV_EVENT_LOG_MESSAGE, [=](mpv_event *event) {
    logMessage(static_cast<mpv_event_log_message*>(event->data));
  });
  setEngineEventCallback(MPV_EVENT_IDLE, [=](mpv_event*) {
    emit playStateChanged(playState = Idle);
  });
  setEngineEventCallback(MPV_EVENT_START_FILE, [=](mpv_event*) {
    emit playStateChanged(playState = Loading);
  });
  setEngineEventCallback(MPV_EVENT_FILE_LOADED, [=](mpv_event*) {
    emit playStateChanged(playState = Playing);
  });
  setEngineEventCallback(MPV_EVENT_END_FILE, [=](mpv_event*) {
    if(playState == Loading)
      emit playStateChanged(playState = Failed);
    else
      emit playStateChanged(playState = Stopped);
  });

  // Setup the callback that will make QtQuick update and redraw if there
  // is a new video frame. Use a queued connection: this makes sure the
  // update() function is run on the GUI thread.
  mpv_gl = (mpv_opengl_cb_context *)mpv_get_sub_api(mpv, MPV_SUB_API_OPENGL_CB);
  if (!mpv_gl)
    throw std::runtime_error("OpenGL not compiled in");
  mpv_opengl_cb_set_update_callback(mpv_gl, MpvObject::on_update, (void *)this);
  connect(this, &MpvObject::onUpdate,
          this, &MpvObject::update,
          Qt::QueuedConnection);

  // Setup the callback, like on_update, via signals and slots we
  // ensure we're operating on the GUI thread.
  mpv_set_wakeup_callback(mpv, wakeup, this);
  connect(this, &MpvObject::onMpvEvents,
          this, &MpvObject::mpvEvents,
          Qt::QueuedConnection);
}

MpvObject::~MpvObject() {
  if (mpv_gl)
    mpv_opengl_cb_set_update_callback(mpv_gl, NULL, NULL);
}

void MpvObject::on_update(void *ctx) {
  MpvObject *self = (MpvObject *)ctx;
  emit self->onUpdate();
}

void MpvObject::mpvEvents() {
  // Process all events, until the event queue is empty.
  while (mpv) {
    mpv_event *event = mpv_wait_event(mpv, 0);
    if (!event || event->event_id == MPV_EVENT_NONE)
      break;
    else {
      auto it = eventCallbacks.find(event->event_id);
      if(it != eventCallbacks.end())
        (*it)(event);
    }
  }
}

void MpvObject::propertyChange(mpv_event_property *prop) {
  if(!prop) return;
  auto it = propertyCallbacks.find(prop->name);
  if(it != propertyCallbacks.end()) {
    if(prop->data == nullptr) return;
    const QVariant val = mpv::qt::node_to_variant((const mpv_node*)prop->data);
    if(it->second)
      it->second = false;
    else
      it->first(val);
  }
}

void MpvObject::logMessage(mpv_event_log_message *msg) {
  if(!msg) return;
  qDebug() << rtrim(msg->text).toUtf8().constData();
}

QVariant MpvObject::command(const QVariant &params) {
  if(!mpv) return QVariant();
  if(!params.canConvert<QVariantList>())
    return mpv::qt::command(mpv, QVariantList{params});
  else
    return mpv::qt::command(mpv, params);
}

void MpvObject::command_async(const QVariant &params) {
  if(!mpv) return;
  if(!params.canConvert<QVariantList>())
    mpv::qt::command_async(mpv, 0, QVariantList{params});
  else
    mpv::qt::command_async(mpv, 0, params);
}

QVariant MpvObject::engineProperty(QString name) const {
  if(!mpv) return QVariant();
  return mpv::qt::get_property(mpv, name.toUtf8().constData());
}

bool MpvObject::setEngineProperty(QString name, const QVariant &value) {
  if(!mpv) return false;
  return mpv::qt::set_property(mpv, name.toUtf8().constData(), value);
}

bool MpvObject::setEnginePropertyAsync(QString name, const QVariant &value) {
  if(!mpv) return false;
  auto it = propertyCallbacks.find(name);
  if(it != propertyCallbacks.end())
    it->second = true;
  return mpv::qt::set_property_async(mpv, 0, name.toUtf8().constData(), value);

}

void MpvObject::setEngineLogLevel(QString level) {
  if(!mpv) return;
  mpv_request_log_messages(mpv, level.toUtf8().constData());
}

void MpvObject::setEngineConfig(const QVariantMap &config) {
  for(QVariantMap::const_iterator conf = config.begin();
      conf != config.end(); conf++)
    setEngineProperty(conf.key().toUtf8().constData(), conf.value());
}

void MpvObject::setEnginePropertyCallback(QString mpv_name,
                                          MpvPropertyCallback callback) {
  if(!mpv) return;
  propertyCallbacks[mpv_name] = {callback, false};
  mpv::qt::observe_property(mpv, 0, mpv_name.toUtf8().constData());
}

void MpvObject::setEngineEventCallback(const mpv_event_id event,
                                       MpvEventCallback callback) {
  eventCallbacks[event] = callback;
}

QQuickFramebufferObject::Renderer *MpvObject::createRenderer() const {
  window()->setPersistentOpenGLContext(true);
  window()->setPersistentSceneGraph(true);
  return new MpvRenderer(this);
}
