from PyQt5.QtQml import qmlRegisterType
from .FileSystemWatcher import FileSystemWatcher
qmlRegisterType(
  FileSystemWatcher,
  FileSystemWatcher.__name__, 1, 0,
  FileSystemWatcher.__name__
)
