import QtQuick 2.0

Rectangle {
  id: self

  property QtObject state
  property QtObject action

  color: self.state.ui.style.color.background

  Text {
    anchors.centerIn: parent

    color: self.state.ui.style.color.foreground
    text: "terminal goes here"
  }
}
