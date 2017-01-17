#include "application.h"
#include "util.h"

#include <QApplication>
#include <QClipboard>
#include <QUrl>
#include <QList>
#include <QIcon>
#include <QProcess>
#include <QDesktopServices>
#include <QDesktopWidget>
#include <QStyle>
#include <QFileInfo>
#include <QTextStream>
#include <QPointer>

// registered message_handler to send messages to the UI
static QTextStream qStderr(stderr);
static QPointer<Application> self = nullptr;
static QtMessageHandler old_handler = nullptr;
static void message_handler(QtMsgType type,
                            const QMessageLogContext &ctx,
                            const QString &msg) {
  if(self.isNull())
    old_handler(type, ctx, msg);
  else
    QMetaObject::invokeMethod(self, "emitMessage", Qt::QueuedConnection,
                              Q_ARG(QString, msg));
}

Application::Application(QQuickItem *parent):
  QQuickItem(parent) {
  setObjectName("app");
}

Application::~Application() {
  self.clear();
}

void Application::installMessageHandler() {
  self.clear();
  self = this;
  old_handler = qInstallMessageHandler(message_handler);
}

void Application::emitMessage(const QString &msg) {
  qStderr << msg << endl;
  emit message(msg);
}

void Application::newPlayer() {
  // Create new instance
  QProcess::startDetached(QApplication::applicationFilePath(), {});
}

void Application::showInFolder(QString path) {
  QFileInfo fi(path);
  if(!fi.exists())
    return;
  else if(fi.isDir())
    ::showInFolder(fi.absolutePath());
  else if(fi.isFile())
    ::showInFolder(fi.absolutePath(), fi.fileName());
}

void Application::onlineHelp() {
  QDesktopServices::openUrl(QUrl(tr("http://mochi-player.github.io/help/")));
}

QStringList Application::arguments() {
  // Command line arguments
  return QApplication::arguments();
}

QVariant Application::clipboard(QVariant clip) {
  if(clip.isNull())
    return mimeDataToVariant(*QApplication::clipboard()->mimeData());
  else
    QApplication::clipboard()->setText(clip.toString());
  return QVariant();
}

void Application::aboutQt() {
  // Qt's own version dialog
  QApplication::aboutQt();
}

void Application::attach(QJSValue val) {
  // Grap QML JSEngine from any QJSValue
  engine = val.engine();
}

void Application::addObject(QObject *obj) {
  // Make object accessible to QJSEngine
  global().setProperty(obj->objectName().toUtf8().constData(),
                       engine->newQObject(obj));
  if(obj != this)
    obj->setParent(this);
}

void Application::addFunction(QString name, QJSValue func) {
  global().setProperty(name, func);
}

QJSValue Application::evaluate(const QString &cmd) {
  // Evaluate command via QJSEngine
  Q_ASSERT(engine);
  return engine->evaluate(cmd);
}

QJSValue Application::global() {
  Q_ASSERT(engine);
  return engine->globalObject();
}

void Application::setIcon(QWindow *window, QString icon) {
  // Set window's icon (because QML has no good way to do it)
  Q_ASSERT(window);
  window->setIcon(QIcon(icon));
}

void Application::fit(QWindow *win, QRect current, QRect target, int percent) {
  // Fit the window to get currentGeometry to match a percentage of
  //  targetGeometry without getting bigger than the desktop
  Q_ASSERT(win);

  // frame geometry of window (window geometry + window frame)
  QRect wfG = win->frameGeometry();
  // window geometry
  QRect wG = win->geometry();
  // available geometry we're in--(geometry not including the taskbar)
  QRect aG = QApplication::desktop()->availableGeometry();
  // native video aspect ratio
  double a = target.width() / target.height();
  // dimensions of the video we want
  double w, h;

  if(percent == 0) { // fit to window
    // set our current video element dimensions
    w = current.width();
    h = current.height();

    // epsilon comparison, we consider -eps < 0 < eps ==> 0
    double cmp = w/h - a,
        eps = 0.01;

    if(cmp > eps) // too wide
      w = h * a; // width based height
    else if(cmp < -eps) // too long
      h = w / a; // height based on width
  }
  else { // scale to desired dimensions
    double scale = percent / 100.0;
    w = scale * target.width();
    h = scale * target.height();
  }

  // display window dimensions (player display + every thing else)
  double dW = w + (wfG.width() - current.width()),
      dH = h + (wfG.height() - current.height());

  if(dW > aG.width()) { // width is greater, scale height
    dW = aG.width();
    w = dW - (wfG.width() - current.width());
    h = w / a;
    dH = h + (wfG.height() - current.height());
  }
  if(dH > aG.height()) { // if the height is bigger, scale width
    dH = aG.height();
    h = dH - (wfG.height() - current.height());
    w = h * a;
    dW = w + (wfG.width() - current.width());
  }

  // get the centered rectangle we want
  QRect rect = QStyle::alignedRect(Qt::LeftToRight,
                                   Qt::AlignCenter,
                                   QSize(dW, dH),
                                   percent == 0 ? wfG : aG);

  // adjust the rect to compensate for the frame
  // this is required because there is no setFrameGeometry function
  rect.setLeft(rect.left() + (wG.left() - wfG.left()));
  rect.setTop(rect.top() + (wG.top() - wfG.top()));
  rect.setRight(rect.right() - (wfG.right() - wG.right()));
  rect.setBottom(rect.bottom() - (wfG.bottom() - wG.bottom()));

  win->setGeometry(rect);
}

QString Application::serializeTime(double pos, double duration) {
  return ::serializeTime(pos * duration / 100.0, duration);
}

QString Application::serializeMedia(const QVariantMap &media) {
  return ::serializeMedia(media);
}

QString Application::pwd() {
  // Get runtime directory
  return QApplication::applicationDirPath();
}
