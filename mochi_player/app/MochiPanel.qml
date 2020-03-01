import QtQuick 2.0
import QtQuick.Layouts 1.4

Rectangle {
  id: self

  property QtObject state
  property QtObject action

  color: "black"

  MochiSeekbar {
    id: seekbar

    state: self.state
    action: self.action

    anchors.top: self.top
    anchors.left: self.left
    anchors.right: self.right
  }

  RowLayout {
    anchors.top: seekbar.bottom
    anchors.left: self.left
    anchors.right: self.right
    anchors.bottom: self.bottom

    Rectangle {
      color: "red"
      width: 10
      Layout.fillHeight: true
    }
    Rectangle {
      color: "blue"
      width: 10
      Layout.fillHeight: true
    }
  }
}
