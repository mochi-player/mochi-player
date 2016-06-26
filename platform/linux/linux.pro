#TARGET = linux
#TEMPLATE = lib
#CONFIG += staticlib c++11

QT += x11extras
PKGCONFIG += x11

SOURCES += \
  $$PWD/linux_util.cpp
