import QtQuick 2.0
import "../components/seekbar"

Item {
  id: self

  property QtObject state
  property QtObject action

  property double playerTimePos: self.state.player.timePos / self.state.player.duration
  property double previewTimePos
  property bool previewVisible

  Rectangle {
    id: preview

    color: '#aaffffff'
    width: 150
    height: 150
    visible: previewVisible
    border.width: 1
    border.color: '#00000000'
    radius: 5

    x: _minmax(
      Math.floor(previewTimePos * seekbar.width - (preview.width / 2)),
      0,
      seekbar.width - preview.width,
    )

    anchors.bottom: seekbar.top

    Text {
      anchors.fill: parent
      anchors.topMargin: 10
      anchors.bottomMargin: 10
      anchors.leftMargin: 10
      anchors.rightMargin: 10
      wrapMode: Text.WrapAnywhere
      text: JSON.stringify({
        player: {
          timePos: playerTimePos,
        },
        preview: {
          timePos: previewTimePos,
          visible: previewVisible,
        },
      })
    }
  }


  Seekbar {
    id: seekbar

    anchors.left: self.left
    anchors.right: self.right
    anchors.bottom: self.bottom
    anchors.topMargin: 10
    anchors.bottomMargin: 10
    height: 12

    played: playerTimePos
    buffered: Math.min(playerTimePos + 0.1, 1.0)
    ticks: [0.15, 0.35, 0.55, 0.85]
  }

  MouseArea {
    id: mouseArea
    anchors.fill: seekbar
    anchors.topMargin: -20
    anchors.bottomMargin: -20
    acceptedButtons: Qt.LeftButton

    hoverEnabled: true
    onExited: previewVisible = false
    onClicked: function (evt) {
      self.action.player.seekAbsolute(
        _minmax(evt.x / seekbar.width, 0.0, 1.0) * self.state.player.duration
      )
    }
    onPositionChanged: function (evt) {
      previewVisible = true
      previewTimePos = _minmax(evt.x / seekbar.width, 0.0, 1.0)
      if (evt.buttons & Qt.LeftButton) {
        self.action.player.seekAbsolute(
          _minmax(evt.x / seekbar.width, 0.0, 1.0) * self.state.player.duration
        )
      }
    }
  }

  function _minmax(x, min, max) {
    return Math.min(Math.max(x, min), max)
  }
}
