TEMPLATE = app
TARGET = test
QT += testlib
CONFIG += testcase qmltestcase c++11
RESOURCES += $$PWD/test.qrc

SOURCES += \
  $$PWD/test.cpp \
  $$PWD/tst_config.cpp \
  $$PWD/tst_util.cpp

HEADERS += \
  $$PWD/tst_config.h \
  $$PWD/tst_util.h

include($$PWD/../qml/qml.pri)
include($$PWD/../img/img.pri)
include($$PWD/../src/src.pri)

TESTDATA = \
  $$PWD/test1.webm \
  $$PWD/test2.webm

target.path =
INSTALLS += target testfiles

# https://larry-price.com/blog/2013/11/14/copy-data-using-qmake
win32 {
  PWD_WIN = $${PWD}
  PWD_WIN ~= s,/,\\,g
  QMAKE_POST_LINK += $$quote(xcopy $${PWD_WIN}\\$${TESTDATA} $${OUT_PWD_WIN}\\$${TESTDATA} /E)
  QMAKE_CLEAN += /s /f /q $${TESTDATA} && rd /s /q $${TESTDATA}
}
unix {
  QMAKE_POST_LINK += $$quote(cp -rf $${TESTDATA} $${OUT_PWD})
  QMAKE_CLEAN += -r $${TESTDATA}
}
