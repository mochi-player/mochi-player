import QtQuick 2.7
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.0

Dialog {
  id: self

  property QtObject style: QtObject {
    property QtObject font {
      property string normal: "Noto Sans"
      property string code: "monospace"
      property double size: 10.0
    }
  }

  default property alias _content: content.children
  visible: true

  contentItem: Pane {
    anchors.fill: parent

    font.family: self.style.font.normal
    font.pointSize: self.style.font.size

    Item {
      id: content
      anchors.fill: parent
    }
  }
}
