#ifndef APPLICATION_H
#define APPLICATION_H

#include <QObject>
#include <QQuickItem>
#include <QWindow>
#include <QString>
#include <QJSEngine>
#include <QJSValue>
#include <QVariant>

#include "property.h"

class Application : public QQuickItem {
  Q_OBJECT
  Q_CLASSINFO("Version", "2.1.0")

  M_PROPERTY(QString, version, USER true)
  M_PROPERTY(bool, debug, USER true)
  M_PROPERTY(QString, init, USER true)
  M_PROPERTY(int, autoFit, USER true)
  M_PROPERTY(QString, onTop, USER true)
  M_PROPERTY(bool, remaining, USER true)
  M_PROPERTY(QString, lang, USER true)
  M_PROPERTY(bool, screenshotDialog, USER true)
  M_PROPERTY(bool, showAll, USER true)
  M_PROPERTY(int, splitter, USER true)
  M_PROPERTY(bool, hidePopup, USER true)
  M_PROPERTY(bool, hideAllControls, USER true)
  M_PROPERTY(int, width, USER true)
  M_PROPERTY(int, height, USER true)

  M_PROPERTY(QString, url,)
  M_PROPERTY(QStringList, audioFiletypes,)
  M_PROPERTY(QStringList, videoFiletypes,)
  M_PROPERTY(QStringList, mediaFiletypes,)
  M_PROPERTY(QStringList, subtitleFileypes,)
public:
  explicit Application(QQuickItem *parent = 0);
  ~Application();
  QJSEngine *getEngine() { return engine; }

public slots:
  void installMessageHandler();
  void emitMessage(const QString &msg);
signals:
  void message(const QString&);

public slots:
  void newPlayer();
  void showInFolder(QString path);
  void onlineHelp();

  QStringList arguments();
  QVariant clipboard(QVariant clip = QVariant());
  void aboutQt();

protected slots:
  void attach(QJSValue val);
  void addObject(QObject*);
  void addFunction(QString name, QJSValue func);
  QJSValue evaluate(const QString &val);
  QJSValue global();

  void setIcon(QWindow *window, QString icon);
  void fit(QWindow *window, QRect current, QRect target, int perc);
  QString serializeTime(double pos, double duration);
  QString serializeMedia(const QVariantMap &media);
  QString pwd();

private:
  QJSEngine *engine;
};

#endif // APPLICATION_H
