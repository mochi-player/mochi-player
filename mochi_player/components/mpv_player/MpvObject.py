''' Ported to python from https://github.com/mpv-player/mpv-examples/blob/master/libmpv/qml_direct/main.cpp

Handle constructing an Mpv context for a QQuickItem for use in QML
'''

import mpv as pympv
from PyQt5.QtCore import Qt, pyqtSignal, pyqtSlot
from PyQt5.QtQuick import QQuickFramebufferObject
from .MpvRenderer import MpvRenderer

class MpvObject(QQuickFramebufferObject):
  on_update = pyqtSignal()
  on_wakeup = pyqtSignal()

  # Dict<event.id, Set<Function<Event.data>>>
  event_handlers = {}

  def __init__(self, *args, **kwargs):
    super().__init__(*args, **kwargs)
    #
    self.killOnce = False
    #
    import locale
    lc, enc = locale.getlocale(locale.LC_NUMERIC)
    locale.setlocale(locale.LC_NUMERIC, 'C')
    self.mpv = pympv.Context()
    locale.setlocale(locale.LC_NUMERIC, lc)
    #
    self.mpv.set_option('terminal', 'yes')
    self.mpv.set_option('msg-level', 'all=v')
    self.mpv.set_option('hr-seek', 'always')
    #
    self.mpv.initialize()
    self.mpv.set_wakeup_callback(self.on_wakeup.emit)
    self.on_wakeup.connect(self.do_wakeup, Qt.QueuedConnection)
    #
    self.mpv.set_option('vo', 'opengl-cb')
    #
    self.mpv_gl = None

  @pyqtSlot()
  def createRenderer(self):
    self.window().setPersistentOpenGLContext(True)
    self.window().setPersistentSceneGraph(True)
    #
    return MpvRenderer(self)

  @pyqtSlot()
  def requestEvent(self, event_id, event_callback):
    if self.event_handlers.get(event_id) is None:
      self.mpv.request_event(event_id, True)
      self.event_handlers[event_id] = set()
    self.event_handlers[event_id].add(event_callback)

  @pyqtSlot()
  def do_wakeup(self):
    while True:
      event = self.mpv.wait_event(0.01)
      if event.id == pympv.Events.none:
        break
      for event_handler in self.event_handlers.get(event.id, set()):
        event_handler(event.data)

  @pyqtSlot()
  def do_update(self):
    self.update()
