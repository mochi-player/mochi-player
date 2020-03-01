import os
import sys
import logging
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

logging.basicConfig(level=logging.DEBUG)

app = QGuiApplication(sys.argv)

app_root = os.path.dirname(__file__)

engine = QQmlApplicationEngine()
engine.load(os.path.join(app_root, '__main__.qml'))

sys.exit(app.exec_())
