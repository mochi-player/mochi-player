RESOURCES += $$PWD/qml.qrc

lupdate_only {
  SOURCES = \
    $$PWD/../qml/component/*.qml \
    $$PWD/../qml/dialog/*.qml \
    $$PWD/../qml/style/*.qml \
    $$PWD/../qml/widget/*.qml
}

DISTFILES += \
    $$PWD/widget/CheckBox.qml \
    $$PWD/widget/ComboBox.qml \
    $$PWD/widget/RadioButton.qml
