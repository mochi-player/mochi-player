INCLUDEPATH += $$PWD
LIBS += -L../platform/ -lplatform

linux:!android {
  include($$PWD/desktop/desktop.pri)
  include($$PWD/linux/linux.pri)
}

win32 {
  include($$PWD/desktop/desktop.pri)
  include($$PWD/win/win.pri)
}

macx {
  include($$PWD/desktop/desktop.pri)
  include($$PWD/mac/mac.pri)
}

android {
  error("Maybe someday... [https://github.com/mpv-android/mpv-android]")
}

ios {
  error("Maybe someday...")
}
