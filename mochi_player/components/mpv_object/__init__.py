from PyQt5.QtQml import qmlRegisterType
from .MpvObject import MpvObject
qmlRegisterType(
    MpvObject,
    MpvObject.__name__, 1, 0,
    MpvObject.__name__
)
