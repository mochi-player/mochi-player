import QtQuick 2.0
import "../reloadable"

Rectangle {
  color: 'grey'
  anchors.fill: parent

  property QtObject player: QtObject {
    property QtObject props: QtObject {
      id: playerProps
      property double timePos
    }
  }

  property QtObject preview: QtObject {
    property QtObject props: QtObject {
      id: previewProps
      property double timePos
      property bool visible
    }
  }

  Rectangle {
    id: preview

    color: '#aaffffff'
    width: 150
    height: 150
    visible: previewProps.visible
    border.width: 1
    border.color: '#00000000'
    radius: 5

    x: _minmax(
      Math.floor(previewProps.timePos * seekbar.width - (preview.width / 2)),
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
          props: playerProps,
        },
        preview: {
          props: previewProps,
        },
      })
    }
  }


  Reloadable {
    id: seekbar

    source: Qt.resolvedUrl('Seekbar.qml')

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.topMargin: 10
    anchors.bottomMargin: 10
    height: 12

    props: QtObject {
      property double played: playerProps.timePos
      property double buffered: Math.min(playerProps.timePos + 0.1, 1.0)
      property var ticks: [0.15, 0.35, 0.55, 0.85]
    }

  }

  MouseArea {
    id: mouseArea
    anchors.fill: seekbar
    anchors.topMargin: -20
    anchors.bottomMargin: -20
    acceptedButtons: Qt.LeftButton

    hoverEnabled: true
    onExited: previewProps.visible = false
    onClicked: function (evt) {
      playerProps.timePos = _minmax(evt.x / seekbar.width, 0.0, 1.0)
    }
    onPositionChanged: function (evt) {
      previewProps.visible = true
      previewProps.timePos = _minmax(evt.x / seekbar.width, 0.0, 1.0)
      if (evt.buttons & Qt.LeftButton) {
        playerProps.timePos = _minmax(evt.x / seekbar.width, 0.0, 1.0)
      }
    }
  }

  function _minmax(x, min, max) {
    return Math.min(Math.max(x, min), max)
  }
}
