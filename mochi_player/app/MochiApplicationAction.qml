import QtQuick 2.0

QtObject {
  id: self

  property QtObject window: QtObject {
    signal show()
    signal hide()
  }

  property QtObject player: QtObject {
    signal load(var file)
  }

  property QtObject tray: QtObject {
    signal show()
    signal hide()
  }
}
