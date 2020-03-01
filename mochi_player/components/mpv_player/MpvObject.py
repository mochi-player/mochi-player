''' Ported to python from https://github.com/mpv-player/mpv-examples/blob/master/libmpv/qml_direct/main.cpp

Handle constructing an Mpv context for a QQuickItem for use in QML
'''

import mpv as pympv
from PyQt5.QtCore import Qt, pyqtSignal, pyqtSlot
from PyQt5.QtQuick import QQuickItem
from .MpvRenderer import MpvRenderer

class MpvObject(QQuickItem):
  on_update = pyqtSignal()
  on_wakeup = pyqtSignal()

  # Dict<event.id, Set<Function<Event.data>>>
  event_handlers = {}

  def __init__(self, *args, **kwargs):
    super().__init__(*args, **kwargs)
    #
    self.renderer = None
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
    #
    self.mpv.initialize()
    self.mpv.set_wakeup_callback(self.on_wakeup.emit)
    self.on_wakeup.connect(self.do_wakeup, Qt.QueuedConnection)
    #
    self.mpv.set_option('vo', 'opengl-cb')
    #
    self.mpv_gl = self.mpv.opengl_cb_api()
    self.mpv_gl.set_update_callback(self.on_update.emit)
    self.on_update.connect(self.do_update, Qt.QueuedConnection)
    #
    self.windowChanged.connect(self.handleWindowChanged)

  @pyqtSlot()
  def handleWindowChanged(self):
    win = self.window()
    if not win:
      return
    win.beforeSynchronizing.connect(self.sync, Qt.DirectConnection)
    win.sceneGraphInvalidated.connect(self.cleanup, Qt.DirectConnection)
    win.frameSwapped.connect(self.swapped, Qt.DirectConnection)
    win.setClearBeforeRendering(False)

  @pyqtSlot()
  def sync(self):
    if self.killOnce:
      self.cleanup()
    self.killOnce = False
    #
    if not self.renderer:
      self.renderer = MpvRenderer(self.mpv, self.mpv_gl)
      self.window().beforeRendering.connect(self.renderer.paint, Qt.DirectConnection)
    #
    self.renderer.window = self.window()
    self.renderer.size = self.window().size() * self.window().devicePixelRatio()

  @pyqtSlot()
  def swapped(self):
    self.mpv_gl.report_flip(0)

  @pyqtSlot()
  def cleanup(self):
    if self.renderer:
      self.render = None

  @pyqtSlot()
  def reinitRenderer(self):
    self.mpv.set_option('stop-playback-on-init-failure', 'no')
    self.killOnce = True
    self.window().update()

  @pyqtSlot()
  def requestEvent(self, event_id, event_callback):
    if self.event_handlers.get(event_id) is None:
      self.mpv.request_event(event_id, True)
      self.event_handlers[event_id] = set()
    self.event_handlers[event_id].add(event_callback)

  @pyqtSlot()
  def do_update(self):
    self.window().update()

  @pyqtSlot()
  def do_wakeup(self):
    while True:
      event = self.mpv.wait_event(0.01)
      if event.id == pympv.Events.none:
        break
      for event_handler in self.event_handlers.get(event.id, set()):
        event_handler(event.data)
