TEMPLATE = app
TARGET = test
QT += testlib
CONFIG += testcase qmltestcase
RESOURCES += $$PWD/test.qrc

SOURCES += \
  $$PWD/test.cpp \
  $$PWD/tst_config.cpp \
  $$PWD/tst_player.cpp \
  $$PWD/tst_util.cpp

HEADERS += \
  $$PWD/tst_config.h \
  $$PWD/tst_player.h \
  $$PWD/tst_util.h

include($$PWD/../src/src.pri)
include($$PWD/../img/img.pri)

target.path =
INSTALLS += target
