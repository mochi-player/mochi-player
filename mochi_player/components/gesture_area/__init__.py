from PyQt5.QtQml import qmlRegisterType
from .GestureArea import GestureArea
qmlRegisterType(
  GestureArea,
  GestureArea.__name__, 1, 0,
  GestureArea.__name__
)
