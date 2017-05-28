#include "input.h"
#include "util.h"

#include <QJSValue>
#include <QCursor>

Input::Input(QQuickItem *parent):
  QQuickItem(parent) {
  setObjectName("inputs");

  // Let Input get all input events
  setAcceptHoverEvents(true);
  setAcceptedMouseButtons(Qt::AllButtons);
  setFlags(QQuickItem::ItemAcceptsInputMethod);
  setFocus(true);

  // Prepare activeGestures map
  activeGestures[Qt::LeftButton] = new ActiveGesture("Left");
  activeGestures[Qt::RightButton] = new ActiveGesture("Right");
  activeGestures[Qt::MiddleButton] = new ActiveGesture("Middle");
}

Input::~Input() {
  for(GestureMap::iterator gesture = activeGestures.begin();
      gesture != activeGestures.end(); gesture++)
    delete gesture.value();
  activeGestures.clear();
}

void Input::attach(QJSValue val) {
  // Grap QML JSEngine from any QJSValue
  engine = val.engine();
}

void Input::mouseDoubleClickEvent(QMouseEvent *event) {
  bool accept = false;

  if(event->buttons() & Qt::LeftButton)
    accept = fireMouseEvent("LeftDoubleClick") || accept;
  if(event->buttons() & Qt::RightButton)
    accept = fireMouseEvent("RightDoubleClick") || accept;
  if(event->buttons() & Qt::MiddleButton)
    accept = fireMouseEvent("MiddleDoubleClick") || accept;

  if(accept)
    event->accept();
  else
    event->ignore();
}

void Input::wheelEvent(QWheelEvent *event) {
  bool accept = false;

  QPoint angle = event->angleDelta();
  if(angle.y() > 0)
    accept = fireMouseEvent("WheelUp");
  else
    accept = fireMouseEvent("WheelDown");

  if(accept)
    event->accept();
  else
    event->ignore();
}

void Input::mousePressEvent(QMouseEvent *event) {
  // Begin gestures on mousePress or call mousePress from unaccepted gesture
  for(GestureMap::iterator gesture = activeGestures.begin();
      gesture != activeGestures.end(); gesture++) {
    if(event->button() == gesture.key()) {
      gesture.value()->startPos = event->globalPos();
      gesture.value()->action = QString();
      gesture.value()->params = QJSValue();
      gesture.value()->enabled = true;
      gesture.value()->timer.start();
      // TODO: flag for standard Dragging and don't wait for timerThreshold
    }
  }

  event->accept();
}

void Input::mouseMoveEvent(QMouseEvent *event) {
  // Process gesture recognition and execution
  bool accept = false;

  for(GestureMap::iterator gesture = activeGestures.begin();
      gesture != activeGestures.end(); gesture++) {
    if(gesture.value()->enabled) {
      if(gesture.value()->timer.elapsed() > timerThreshold) {
        QPoint delta = event->globalPos() - gesture.value()->startPos;
        if(gesture.value()->action == QString()) {
          QString action_name = gesture.value()->name+"Drag";
          gesture.value()->params =
              engine->evaluate(getMouseAction(QString(action_name+"!"))).call(
                QJSValueList({QJSValue(gesture.value()->startPos.x()),
                              QJSValue(gesture.value()->startPos.y())}));
          gesture.value()->action = getMouseAction(action_name);
          if(gesture.value()->action == QString()) {
            if(abs(delta.x()) >= abs(delta.y()) + gestureThreshold)
              action_name = gesture.value()->name+"HDrag";
            else if(abs(delta.y()) >= abs(delta.x()) + gestureThreshold)
              action_name = gesture.value()->name+"VDrag";
            else
              continue; // TODO: DDrag
            gesture.value()->params =
                engine->evaluate(getMouseAction(QString(action_name+"!"))).call(
                  QJSValueList({QJSValue(gesture.value()->startPos.x()),
                                QJSValue(gesture.value()->startPos.y())}));
            gesture.value()->action = getMouseAction(action_name);
          }
          if(gesture.value()->action != QString()) {
            gesture.value()->refreshTimer.start();
            accept = true;
          }
        }
        else {
          if(gesture.value()->refreshTimer.elapsed() > refreshRate) {
            engine->evaluate(gesture.value()->action).call(
                QJSValueList({QJSValue(delta.x()),
                              QJSValue(delta.y()),
                              gesture.value()->params}));
            gesture.value()->refreshTimer.start();
          }
          accept = true;
        }
      }
    }
  }

  if(accept)
    setCursor(QCursor(Qt::PointingHandCursor));

  event->accept();
}

void Input::mouseReleaseEvent(QMouseEvent *event) {
  // Finalize gestures on release
  for(GestureMap::iterator gesture = activeGestures.begin();
      gesture != activeGestures.end(); gesture++) {
    if(gesture.value()->enabled &&
       (event->button() == gesture.key())) {
      if(gesture.value()->action == QString())
        fireMouseEvent(gesture.value()->name+"Click");
      gesture.value()->enabled = false;
    }
  }

  setCursor(QCursor(Qt::ArrowCursor));
  event->accept();
}

void Input::keyPressEvent(QKeyEvent *event) {
  if(fireKeyEvent(
       QKeySequence(event->modifiers() | event->key()).toString()))
    event->accept();
  else
    event->ignore();
}

void Input::keyReleaseEvent(QKeyEvent *event) {
  if(fireKeyEvent(
       QKeySequence(event->modifiers() | event->key()).toString()+QString("*")))
    event->accept();
  else
    event->ignore();
}

QString Input::getMouseAction(const QString &event) {
  auto c = mouse.find(event);
  if(c != mouse.end())
    return c.value().toString();
  return QString();
}

bool Input::fireMouseEvent(const QString &event) {
  auto c = mouse.find(event);
  if(c != mouse.end()) {
    engine->evaluate(c.value().toString());
    return true;
  }
  return false;
}

bool Input::fireKeyEvent(const QString &event) {
  auto c = key.find(event);
  if(c != key.end()) {
    engine->evaluate(c.value().toString());
    return true;
  }
  return false;
}

Input::ActiveGesture::ActiveGesture(const QString &name)
  : name(name), enabled(false) {}
