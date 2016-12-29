import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../style"
import "../widget"

Dialog {
  property bool valid: h.value*60*60+m.value*60+s.value < player.duration
  width: 310
  height: 45

  RowLayout {
    anchors.fill: parent
    Image {
      Layout.alignment: Qt.AlignVCenter
      source: valid ? 'qrc:/valid.svg' : 'qrc:/invalid.svg'
    }
    Pane {
      Layout.fillWidth: true
      Layout.fillHeight: true

      Row {
        anchors.fill: parent
        MochiSpinBox {
          id: h
          enabled: player.duration > 60*60
          suffix: qsTr(" hr")
          maximumValue: 99
        }
        Text {
          text: " :"
        }
        MochiSpinBox {
          id: m
          enabled: player.duration > 60
          suffix: qsTr(" min")
          maximumValue: 59
        }
        Text {
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
    Item { width: Style.spacing.margin }
    Button {
      Layout.alignment: Qt.AlignVCenter
      text: qsTr("OK")
      onClicked: accept()
      enabled: valid
    }
  }
}
