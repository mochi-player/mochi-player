import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "."

TextField {
  id: field
  property color background: MochiStyle.background.normal

  font.family: MochiStyle.font.normal
  font.pointSize: MochiStyle.font.size
  style: TextFieldStyle {
    font: parent.font
    textColor: MochiStyle.text.normal
    placeholderTextColor: MochiStyle.text.soft
    background: Rectangle {
      color: field.background
    }
  }
}
