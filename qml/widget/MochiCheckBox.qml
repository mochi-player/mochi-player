import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "."

CheckBox {
  id: obj
  style: CheckBoxStyle {
    label: MochiText {
      anchors.centerIn: parent
      text: obj.text
    }
  }
}
