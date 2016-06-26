import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../widget"

MochiDialog {
  property bool valid: h.value*60*60+m.value*60+s.value < player.duration
  width: 310
  height: 45

  RowLayout {
    anchors.fill: parent
    Image {
      Layout.alignment: Qt.AlignVCenter
      source: valid ? 'qrc:/valid.svg' : 'qrc:/invalid.svg'
    }
    Rectangle {
      Layout.fillWidth: true
      Layout.fillHeight: true
      color: MochiStyle.background.accent
      Row {
        anchors.fill: parent
        MochiSpinBox {
          id: h
          enabled: player.duration > 60*60
          suffix: qsTr(" hr")
          maximumValue: 99
        }
        MochiText {
          text: " :"
        }
        MochiSpinBox {
          id: m
          enabled: player.duration > 60
          suffix: qsTr(" min")
          maximumValue: 59
        }
        MochiText {
          text: " :"
        }
        MochiSpinBox {
          id: s
          enabled: player.duration > 0
          suffix: qsTr(" sec")
          maximumValue: 59
        }
      }
    }
    Item { width: MochiStyle.spacing.margin }
    MochiTextButton {
      Layout.alignment: Qt.AlignVCenter
      text: qsTr("OK")
      onClicked: accept()
      enabled: valid
    }
  }
}
