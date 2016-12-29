import QtQuick 2.7
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../style"

Dialog {
  default property alias _content: content.children
  visible: true

  contentItem: Pane {
    anchors.fill: parent

    Material.foreground: Style.color.foreground
    Material.background: Style.color.background
    Material.accent: Style.color.accent
    Material.primary: Style.color.primary

    font.family: Style.font.normal
    font.pointSize: Style.font.size

    Item {
      id: content
      anchors.fill: parent
    }
  }
}
