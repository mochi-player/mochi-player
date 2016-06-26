import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "."

MenuBar {
  style: MenuBarStyle {
    id: mbstyle
    padding {
      left: 8
      right: 8
      top: 3
      bottom: 3
    }

    background: Rectangle {
      id: rect
      color: MochiStyle.background.normal
    }

    itemDelegate: Rectangle {
      implicitWidth: l.contentWidth * 1.4
      implicitHeight: l.contentHeight
      color: styleData.selected || styleData.open ? MochiStyle.background.accent : MochiStyle.background.normal
      Label {
        id: l
        anchors.horizontalCenter: parent.horizontalCenter
        color: (styleData.selected || styleData.open) ? MochiStyle.text.accent : MochiStyle.text.normal
        font.family: MochiStyle.font.normal
        font.wordSpacing: 10
        text: mbstyle.formatMnemonic(styleData.text, true)
      }
    }

    menuStyle: MenuStyle {
      id: mstyle

      frame: Rectangle {
        color: MochiStyle.background.normal
        border.color: MochiStyle.background.soft
        border.width: 1
      }

      itemDelegate {
        background: Rectangle {
          color:  (styleData.selected || styleData.open) ? MochiStyle.background.accent : MochiStyle.background.normal
        }

        label: Label {
          color: styleData.selected ? MochiStyle.text.accent : MochiStyle.text.normal
          font.family: MochiStyle.font.normal
          text: mstyle.formatMnemonic(styleData.text, true)
        }

        submenuIndicator: Text {
          text: "\u25ba"
          font: mstyle.font
          color: (styleData.selected || styleData.open) ? MochiStyle.text.accent : MochiStyle.text.normal
        }

        shortcut: Label {
          color: styleData.selected ? MochiStyle.text.accent : MochiStyle.text.normal
          text: styleData.shortcut
        }

        checkmarkIndicator: CheckBox {
          checked: styleData.checked

          style: CheckBoxStyle {

            indicator: Rectangle {
              implicitWidth: mstyle.font.pixelSize
              implicitHeight: implicitWidth
              radius: 2
              color: control.checked ?  MochiStyle.background.accent : MochiStyle.background.normal
              border.color: MochiStyle.background.accent
              border.width: 2
              Rectangle {
                visible: control.checked
                color: MochiStyle.background.invert
                border.color: MochiStyle.background.accent
                border.width: 2
                radius: 2
                anchors.fill: parent
              }
            }
            spacing: 10
          }
        }
      }

      separator: Rectangle {
        width: parent.width
        implicitHeight: 1
        color: MochiStyle.background.soft
      }
    }
  }
}
