from PyQt5.QtQml import qmlRegisterSingletonType
from .FitWindow import FitWindow
qmlRegisterSingletonType(
  FitWindow,
  FitWindow.__name__, 1, 0,
  FitWindow.__name__,
  lambda qml_engine, *args, **kwargs: FitWindow()
)
