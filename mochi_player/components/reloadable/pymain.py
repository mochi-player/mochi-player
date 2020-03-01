from PyQt5.QtCore import pyqtSignal, pyqtProperty
from PyQt5.QtQuick import QQuickItem
from PyQt5.QtQml import qmlRegisterType

class PyMain(QQuickItem):
  bChanged = pyqtSignal(str)

  def __init__(self, *args, **kwargs):
    super().__init__(*args, **kwargs)
    self._b = '?'

  @pyqtProperty(str, notify=bChanged)
  def b(self):
    return self._b
  
  @b.setter
  def b(self, v):
    self._b = v

qmlRegisterType(
  PyMain,
  PyMain.__name__, 1, 0,
  PyMain.__name__
)
