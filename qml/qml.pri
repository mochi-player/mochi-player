RESOURCES += $$PWD/qml.qrc

lupdate_only {
  SOURCES = \
    $$PWD/../qml/component/*.qml \
    $$PWD/../qml/dialog/*.qml \
    $$PWD/../qml/style/*.qml \
    $$PWD/../qml/widget/*.qml
}
