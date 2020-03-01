import QtQuick 2.0

QtObject {
  id: self

  property QtObject window: QtObject {
    signal show()
    signal hide()
  }

  property QtObject player: QtObject {
    signal load(var file)
    signal playPause()
    signal seekAbsolute(double timePos)
    signal seekRelative(double timePos)
    signal adjustVolume(double volume)
  }

  property QtObject tray: QtObject {
    signal show()
    signal hide()
  }
}
