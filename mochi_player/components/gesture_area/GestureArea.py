'''
Mouse implements the mouse bindings.
'''

import logging
from functools import partial

from PyQt5.Qt import Qt, QObject, QCursor, QTimer, QElapsedTimer
from PyQt5.QtCore import pyqtSignal
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQuick import QQuickItem

emptyCallback = lambda *args, **kwargs: None

class GestureHandler:
  def __init__(self, startPos):
    self.startPos = startPos
    self.action = None
    self.direction = None
    self.lastDelta = 0
    self.timer = QElapsedTimer()
    self.fireTimer = QElapsedTimer()
    # show cursor cue that we're in gesture
    QGuiApplication.setOverrideCursor(QCursor(Qt.PointingHandCursor))

  def __repr__(self):
    return str({
      'startPos': self.startPos,
      'action': self.action,
      'timer': self.timer.elapsed(),
    })

  def __del__(self):
    # end cursor cue
    QGuiApplication.restoreOverrideCursor()


class GestureArea(QQuickItem):
  gesture = pyqtSignal(str, list)
  leftClick = pyqtSignal()
  middleClick = pyqtSignal()
  rightClick = pyqtSignal()
  leftDoubleClick = pyqtSignal()
  middleDoubleClick = pyqtSignal()
  rightDoubleClick = pyqtSignal()
  leftVDrag = pyqtSignal(float)
  leftHDrag = pyqtSignal(float)
  middleVDrag = pyqtSignal(float)
  middleHDrag = pyqtSignal(float)
  rightVDrag = pyqtSignal(float)
  rightHDrag = pyqtSignal(float)
  wheelUp = pyqtSignal()
  wheelDown = pyqtSignal()

  def __init__(self, *args, **kwargs):
    super().__init__(*args, **kwargs)
    self._buttonString = {
      Qt.LeftButton: 'left',
      Qt.RightButton: 'right',
      Qt.MiddleButton: 'middle',
    }

    self._gestureHandler = {}
    self._timerThreshold = 100
    self._doubleClickThreshold = 250
    self._gestureThreshold = 15
    self._gesturePrecision = 4
    self._fireRate = 60

    self._clickHandler = {}
    for btn in self._buttonString.keys():
      self._clickHandler[btn] = QTimer()
      self._clickHandler[btn].setSingleShot(True)
      self._clickHandler[btn].setInterval(self._doubleClickThreshold)
      self._clickHandler[btn].timeout.connect(
        partial(self._mouseClickEvent, btn)
      )

    self.setAcceptedMouseButtons(Qt.AllButtons)

  def mousePressEvent(self, event):
    ''' Handle mouse press, creating a gesture handler '''
    # create a gesture handler for this button
    self._gestureHandler[event.button()] = GestureHandler(
        event.globalPos())
    self._gestureHandler[event.button()].timer.start()
    event.accept()

  def mouseMoveEvent(self, event):
    ''' Process gesture handlers when mouse moves '''
    # are there any gestures?
    if self._gestureHandler:
      for button, handler in self._gestureHandler.items():
        # has it been long enough to initiate the gesture?
        if handler.timer.elapsed() > self._timerThreshold:
          # get the mouse position difference
          delta = event.globalPos() - handler.startPos
          # do we not know what type of gesture we've made yet?
          if handler.direction == None:
            # change in x > change in y [horizontal]
            if abs(delta.x()) >= abs(delta.y()) + self._gestureThreshold:
              # set registered command as action
              handler.direction = 'H'
              handler.action = self._getMouse(self._verboseMouse(
                  '%sHDrag' % (self._buttonString.get(button))))
              handler.fireTimer.start()
            # change in y > change in x [vertical]
            elif abs(delta.y()) >= abs(delta.x()) + self._gestureThreshold:
              # set registered command as action
              handler.direction = 'V'
              handler.action = self._getMouse(self._verboseMouse(
                  '%sVDrag' % (self._buttonString.get(button))))
              handler.fireTimer.start()
          # we already have our gesture command trigger
          elif handler.action is not None and handler.fireTimer.elapsed() > self._fireRate:
            handler.fireTimer.restart()
            # apply the command, passing the position change
            if handler.direction == 'H':
              d = delta.x() * self._gesturePrecision / self.width()
            elif handler.direction == 'V':
              d = delta.y() * self._gesturePrecision / self.height()
            else:
              d = 0
            self._fireAction(handler.action, d - handler.lastDelta)
            handler.lastDelta = d
      event.accept()
    else:
      event.ignore()

  def mouseReleaseEvent(self, event):
    ''' Process release event, ending gestures and/or calling clicks '''
    button = event.button()
    handler = self._gestureHandler.get(button)
    logging.debug(handler.action)
    click = True
    # was a handler initiated?
    if handler:
      # click if an action was not initiated
      click = handler.direction == None
      # cleanup
      del self._gestureHandler[button]
    # was there a click?
    if click:
      if not self._hasDoubleClick(button):
        # Just trigger mouse click, there is no double click to watch for
        if self._mouseClickEvent(button):
          event.accept()
        else:
          event.ignore()
      else:
        # trigger _mouseClickEvent in a little bit, but cancel if we trigger a _mouseDoubleClickEvent
        handler = self._clickHandler.get(button)
        if not handler.isActive():
          # trigger a click if nothing else happens
          handler.start()
          event.accept()
        else: # double click occured
          # ensure click handler doesn't activate
          handler.stop()
          if self._mouseDoubleClickEvent(button):
            event.accept()
          else:
            event.ignore()
    else:
      event.ignore()

  def _fireAction(self, action, *args):
    signal = getattr(self, action)
    if args:
      signal.emit(*args)
    else:
      signal.emit()
    self.gesture.emit(action, list(args))

  def _hasDoubleClick(self, button):
    return self._getMouse(
      '%sDoubleClick' % (self._buttonString.get(button))
    ) is not None

  def _mouseClickEvent(self, button):
    action = self._getMouse(self._verboseMouse(
        '%sClick' % (self._buttonString.get(button))))
    # action assigned?
    if action:
      # execute command
      self._fireAction(action)
      return True
    return False

  def _mouseDoubleClickEvent(self, button):
    action = self._getMouse(self._verboseMouse(
        '%sDoubleClick' % (self._buttonString.get(button))))
    # action assigned?
    if action:
      # execute command
      self._fireAction(action)
      return True
    return False

  def wheelEvent(self, event):
    # get wheel movement
    angle = event.angleDelta()
    # grab action
    action = self._getMouse(self._verboseMouse(
        'wheel%s' % ('Up' if angle.y() > 0 else 'Down')))
    # action assigned?
    if action:
      # execute command
      self._fireAction(action)
      event.accept()
    else:
      event.ignore()

  def _getMouse(self, key, defaultValue=None):
    if self.receivers(getattr(self, key)) > 0:
      return key
    else:
      return defaultValue

  def _verboseMouse(self, text):
    ''' Input debugging wrapper '''
    logging.debug('[input.mouse]: %s' % (text))
    return text
