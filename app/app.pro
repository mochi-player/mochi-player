TARGET = mochi-player
VERSION = 2.1.0
TEMPLATE = app
CONFIG += staticlib c++11

SOURCES += $$PWD/main.cpp

include($$PWD/app.pri)

target.path = /usr/bin/
INSTALLS += target
