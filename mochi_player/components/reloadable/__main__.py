import os
import sys
import logging
from PyQt5.QtGui import QGuiApplication
from .ReloadableEngine import ReloadableEngine
from ..filesystem_watcher import FileSystemWatcher

logging.basicConfig(level=logging.DEBUG)

app = QGuiApplication(sys.argv)

app_root = os.path.dirname(__file__)

engine = ReloadableEngine()
engine.load(os.path.join(app_root, '__main__.qml'))

sys.exit(app.exec_())
