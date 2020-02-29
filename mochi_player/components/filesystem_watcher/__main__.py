import os
import sys
import logging
logging.basicConfig(level=logging.DEBUG)
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from . import FileSystemWatcher

app = QGuiApplication(sys.argv)

app_root = os.path.dirname(__file__)
engine = QQmlApplicationEngine()

engine.load(os.path.join(app_root, '__main__.qml'))

sys.exit(app.exec_())
