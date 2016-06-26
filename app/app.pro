TARGET = mochi-player
VERSION = 2.1.0
TEMPLATE = app
CONFIG += staticlib c++11

SOURCES += $$PWD/main.cpp

include($$PWD/../qml/qml.pri)
include($$PWD/../img/img.pri)
include($$PWD/../src/src.pri)

target.path = /usr/bin/
INSTALLS += target
