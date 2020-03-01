''' Ported to python from https://github.com/mpv-player/mpv-examples/blob/master/libmpv/qml_direct/main.cpp

Handle initializing the mpv GL context and using it for drawing this QObject.
'''

from PyQt5.QtCore import Qt, QObject, pyqtSlot, pyqtSignal
from PyQt5.QtQuick import QQuickFramebufferObject
from PyQt5.QtGui import QOpenGLContext

def get_proc_address(name):
  glctx = QOpenGLContext.currentContext()
  if not glctx:
    return 0
  return int(glctx.getProcAddress(name))

class MpvRenderer(QQuickFramebufferObject.Renderer):
  def __init__(self, obj, *args, **kwargs):
    super().__init__(*args, **kwargs)
    self.obj = obj

  @pyqtSlot()
  def createFramebufferObject(self, size):
    if self.obj.mpv_gl is None:
      self.obj.mpv_gl = self.obj.mpv.opengl_cb_api()
      self.obj.mpv_gl.set_update_callback(self.obj.on_update.emit)
      self.obj.on_update.connect(self.obj.do_update, Qt.QueuedConnection)
      self.obj.mpv_gl.init_gl(None, get_proc_address)
    #
    return super().createFramebufferObject(size)

  @pyqtSlot()
  def render(self):
    win = self.obj.window()
    win.resetOpenGLState()
    fbo = self.framebufferObject()
    self.obj.mpv_gl.draw(
      fbo.handle(),
      fbo.width(),
      fbo.height()
    )
    win.resetOpenGLState()
