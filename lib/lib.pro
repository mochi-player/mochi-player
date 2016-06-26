TARGET = lib
TEMPLATE = lib
CONFIG += staticlib c++11

QT += quick
CONFIG += link_pkgconfig
PKGCONFIG += mpv

HEADERS += \
  $$PWD/lib_player.h \
  $$PWD/mpv.h \
  $$PWD/qthelper.hpp

SOURCES += \
  $$PWD/mpv.cpp
