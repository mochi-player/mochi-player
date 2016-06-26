TARGET = platform
TEMPLATE = lib
CONFIG += staticlib c++11

HEADERS += \
  $$PWD/util.h

SOURCES += \
  $$PWD/util.cpp

linux:!android {
  include($$PWD/linux/linux.pro)
}

win32 {
  include($$PWD/win/win.pro)
}

macx {
  include($$PWD/mac/mac.pro)
}

android {
  error("Maybe someday... [https://github.com/mpv-android/mpv-android]")
}

ios {
  error("Maybe someday...")
}
