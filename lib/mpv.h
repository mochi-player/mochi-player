// https://github.com/mpv-player/mpv-examples/tree/master/libmpv/qt
// https://github.com/mpv-player/mpv-examples/blob/master/libmpv/qt_opengl
// https://github.com/mpv-player/mpv-examples/blob/master/libmpv/qml

#ifndef MPVRENDERER_H_
#define MPVRENDERER_H_

#include <QQuickItem>
#include <QQuickFramebufferObject>
#include <QObject>
#include <QPair>
#include <QMap>

#include <functional>

#include <mpv/client.h>
#include <mpv/opengl_cb.h>
#include "qthelper.hpp"

class MpvRenderer;

typedef std::function<void(QVariant)> MpvPropertyCallback;
typedef std::function<void(mpv_event*)> MpvEventCallback;

enum PlayState {
  Idle,
  Loading,
  Playing,
  Stopped,
  Failed
};

class MpvObject : public QQuickFramebufferObject {
    Q_OBJECT

    friend class MpvRenderer;
  public:
    MpvObject(QQuickItem *parent = 0);
    virtual ~MpvObject();
    virtual Renderer *createRenderer() const;

  public slots:
    void command(const QVariant &params);
    QVariant engineProperty(QString name) const;
    bool setEngineProperty(QString name, const QVariant &value);
    void setEngineOption(QString name, const QVariant &value);
    void setEngineConfig(const QVariantMap &config);
    void setEngineLogLevel(QString level);

  protected slots:
    void setPropertyCallback(QString mpv_name, MpvPropertyCallback callback);
    void setEventCallback(const mpv_event_id event, MpvEventCallback callback);

  private slots:
    void mpvEvents();
    void propertyChange(mpv_event_property *prop);
    void logMessage(mpv_event_log_message *msg);

  signals:
    void onUpdate();
    void onMpvEvents();
    void playStateChanged(const PlayState &playState);

  private:
    static void on_update(void *ctx);

    mpv::qt::Handle mpv;
    mpv_opengl_cb_context *mpv_gl;

    QMap< QString, QPair<MpvPropertyCallback, bool> > propertyCallbacks;
    QMap< mpv_event_id, MpvEventCallback > eventCallbacks;

    PlayState playState;
};

#endif
