import os
import sys
import logging
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtCore import QLoggingCategory
from .. import filesystem_watcher, reloadable
from ..reloadable import ReloadableEngine

logging.basicConfig(level=logging.DEBUG)
QLoggingCategory.setFilterRules('qt.qml.binding.removal.info=true')

app = QGuiApplication(sys.argv)

app_root = os.path.dirname(__file__)

engine = ReloadableEngine()
engine.load(os.path.join(app_root, '__main__.qml'))

sys.exit(app.exec_())
