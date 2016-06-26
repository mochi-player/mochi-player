import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import "."

Dialog {
  default property alias contents: content.children
  visible: true
  contentItem: Rectangle {
    anchors.fill: parent
    color: MochiStyle.color.background
    Item {
      id: content
      anchors.fill: parent
      anchors.margins: MochiStyle.spacing.margin
    }
  }
}
