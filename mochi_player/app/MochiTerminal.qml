import QtQuick 2.0

Rectangle {
  id: self

  property QtObject state
  property QtObject action

  color: "black"

  Text {
    anchors.centerIn: parent

    color: "white"
    text: "terminal goes here"
  }
}
