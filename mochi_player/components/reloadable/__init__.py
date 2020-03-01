from PyQt5.QtQml import qmlRegisterSingletonType
from .ReloadableEngine import ReloadableEngine
qmlRegisterSingletonType(
  ReloadableEngine,
  ReloadableEngine.__name__, 1, 0,
  ReloadableEngine.__name__,
  lambda qml_engine, *args, **kwargs: qml_engine
)
