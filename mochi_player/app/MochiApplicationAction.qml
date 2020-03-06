import QtQuick 2.0

QtObject {
  id: self

  property QtObject window: QtObject {
    signal show()
    signal toggleFullscreen()
    signal toggleDimLights()
    signal hide()
  }

  property QtObject dialog: QtObject {
    signal open()
    signal openLocation()
    signal jump()
  }

  property QtObject player: QtObject {
    signal load(var file)
    signal playPause()
    signal playNext()
    signal playPrev()
    signal seekAbsolute(double timePos)
    signal seekRelative(double timePos)
    signal adjustVolume(double volume)
    signal setSpeed(double speed)
    signal toggleMute()
    signal toggleSubtitles()
    signal takeScreenshot()
    signal frameStep()
    signal frameBackStep()
  }

  property QtObject ui: QtObject {
    signal toggleMenu()
    signal togglePlaylist()
    signal toggleTerminal()
    signal toggleSnapshotMode()
  }

  property QtObject tray: QtObject {
    signal show()
    signal hide()
  }
}
