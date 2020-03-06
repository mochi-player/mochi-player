import os
import sys
import logging
logging.basicConfig(level=logging.DEBUG)
# from PyQt5.QtGui import QGuiApplication
from PyQt5.QtWidgets import QApplication
from PyQt5.QtQml import QQmlApplicationEngine

from . import utils
from mochi_player.components import (
  gesture_area,
  mpv_player,
)

# app = QGuiApplication(sys.argv)
app = QApplication(sys.argv)

app_root = os.path.dirname(__file__)
engine = QQmlApplicationEngine()

engine.load(os.path.join(app_root, '__main__.qml'))

sys.exit(app.exec_())
