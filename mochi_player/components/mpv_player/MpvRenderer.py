''' Ported to python from https://github.com/mpv-player/mpv-examples/blob/master/libmpv/qml_direct/main.cpp

Handle initializing the mpv GL context and using it for drawing this QObject.
'''

from PyQt5.QtCore import QObject, pyqtSlot
from PyQt5.QtGui import QOpenGLContext

def get_proc_address(name):
  glctx = QOpenGLContext.currentContext()
  if not glctx:
    return 0
  return int(glctx.getProcAddress(name))

class MpvRenderer(QObject):
  def __init__(self, a_mpv, a_mpv_gl, *args, **kwargs):
    super().__init__(*args, **kwargs)
    self.mpv = a_mpv
    self.mpv_gl = a_mpv_gl
    self.mpv_gl.init_gl(None, get_proc_address)
    self.window = None

  @pyqtSlot()
  def paint(self):
    if self.window:
      self.window.resetOpenGLState()
      self.mpv_gl.draw(0, self.size.width(), -self.size.height())
      self.window.resetOpenGLState()
