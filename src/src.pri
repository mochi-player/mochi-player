INCLUDEPATH += $$PWD
LIBS += -L../src/ -lsrc

QT += qml quick

include($$PWD/../lib/lib.pri)
include($$PWD/../platform/platform.pri)
