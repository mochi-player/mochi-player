from PyQt5.QtQml import qmlRegisterType
from .MpvPlayer import MpvPlayer
qmlRegisterType(
    MpvPlayer,
    MpvPlayer.__name__, 1, 0,
    MpvPlayer.__name__
)
