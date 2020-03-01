import QtQuick 2.0
import GestureArea 1.0

Item {
  id: self

  property QtObject state
  property QtObject action
    
  GestureArea {
    id: gestureArea

    anchors.fill: parent

    onRightClick: self.action.player.playPause()
    onLeftHDrag: function (val) {
      self.action.player.seekRelative(
        val * self.state.player.duration / 10
      )
    }
    onLeftVDrag: function (val) {
      self.action.player.adjustVolume(
        - val * 100
      )
    }
  }
}
