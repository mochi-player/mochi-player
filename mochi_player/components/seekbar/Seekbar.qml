import QtQuick 2.0

Rectangle {
  id: self

  property var played
  property var buffered
  property var ticks: []

  property QtObject style: QtObject {
    property color played: '#008098'
    property color buffered: '#005068'
    property color pending: '#1a1a1a'
    property color tick: '#ffffff'
  }

  Rectangle {
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right

    color: style.pending
  }

  Rectangle {
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left

    color: style.buffered
    width: Math.floor(self.buffered * parent.width)
  }

  Rectangle {
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left

    color: style.played
    width: Math.floor(self.played * parent.width)
  }

  Repeater {
    model: self.ticks

    Rectangle {
      anchors.topMargin: 2
      anchors.bottomMargin: 2
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      
      x: Math.floor(modelData * parent.width)
      width: 1

      color: style.tick
    }
  }
}