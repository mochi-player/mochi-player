import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "."

TextArea {
  id: txt
  property alias borderWidth: b.width
  property color backgroundColor: MochiStyle.background.normal

  font.family: MochiStyle.font.normal
  font.pointSize: MochiStyle.font.size
  textColor: MochiStyle.text.normal
  textMargin: MochiStyle.spacing.padding

  style: TextAreaStyle {
    backgroundColor: txt.backgroundColor
  }

  Rectangle {
    id: b
    color: "transparent"
    anchors.fill: parent
    border.color: MochiStyle.background.normal
    border.width: 1
  }
}
