TEMPLATE = app
TARGET = test
QT += testlib
CONFIG += testcase qmltestcase c++11 console
CONFIG -= app_bundle
RESOURCES += $$PWD/test.qrc

SOURCES += \
  $$PWD/test.cpp \
  $$PWD/tst_config.cpp \
  $$PWD/tst_util.cpp

HEADERS += \
  $$PWD/tst_config.h \
  $$PWD/tst_util.h

TEST_DATA = \
  $$PWD/test1.webm \
  $$PWD/test2.webm


include($$PWD/../app/app.pri)


# testdata
isEmpty(CP):CP=cp -rf
testdata.input = TEST_DATA
testdata.output = ${QMAKE_FILE_BASE}${QMAKE_FILE_EXT}
testdata.commands += $$CP ${QMAKE_FILE_NAME} ${QMAKE_FILE_OUT}
testdata.CONFIG = target_predeps no_link
QMAKE_EXTRA_COMPILERS += testdata


# noinstall
target.files =
INSTALLS += target
