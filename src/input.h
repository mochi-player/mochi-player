#ifndef INPUT_H
#define INPUT_H

#include <QObject>
#include <QQuickItem>
#include <QVariantMap>
#include <QMouseEvent>
#include <QWheelEvent>
#include <QKeyEvent>
#include <QJSEngine>
#include <QJSValue>
#include <QElapsedTimer>
#include <QMap>
#include <QString>
#include <QPoint>

#include "property.h"

class Input : public QQuickItem {
  Q_OBJECT
  Q_CLASSINFO("Version", "2.1.0")

  M_PROPERTY(QVariantMap, key, USER true)
  M_PROPERTY(QVariantMap, mouse, USER true)
  M_PROPERTY(bool, gestures, USER true)

public:
  explicit Input(QQuickItem *parent = 0);
  ~Input();

public slots:

protected slots:
  void attach(QJSValue val);

  void mouseMoveEvent(QMouseEvent *event);
  void mousePressEvent(QMouseEvent *event);
  void mouseReleaseEvent(QMouseEvent *event);
  void mouseDoubleClickEvent(QMouseEvent *event);
  void wheelEvent(QWheelEvent *event);
  void keyPressEvent(QKeyEvent *event);
  void keyReleaseEvent(QKeyEvent *event);

  QString getMouseAction(const QString &event);
  bool fireMouseEvent(const QString &event);
  bool fireKeyEvent(const QString &event);

private slots:

private:
  QJSEngine *engine;

  const int timerThreshold = 200;
  const int refreshRate = 30;
  const int gestureThreshold = 15;

  struct ActiveGesture {
    ActiveGesture(const QString &name);

    const QString name;
    bool enabled;
    QString action;
    QPoint startPos;
    QJSValue params;
    QElapsedTimer timer, refreshTimer;
  };
  typedef QMap<Qt::MouseButton, ActiveGesture*> GestureMap;
  GestureMap activeGestures;

};

#endif // INPUT_H
