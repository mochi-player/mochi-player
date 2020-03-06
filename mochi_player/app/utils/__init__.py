from PyQt5.QtCore import pyqtSlot
from PyQt5.QtQml import qmlRegisterSingletonType
from PyQt5.QtQuick import QQuickItem
from .serializeTime import serializeTime

class Utils(QQuickItem):
  @pyqtSlot(float, float, result='QString')
  def serializeTime(self, time, duration):
    return serializeTime(time, duration)

qmlRegisterSingletonType(
  Utils,
  Utils.__name__, 1, 0,
  Utils.__name__,
  lambda qml_engine, *args, **kwargs: Utils()
)
