import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../widget"

Tab {
  property var conf
  title: qsTr("Advanced")

  ColumnLayout {
    anchors.fill: parent

    RowLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft

      MochiGroupBox {
        Layout.alignment: Qt.AlignTop | Qt.AlignLeft
        text: qsTr("Command Line")

        ColumnLayout {
          MochiText {
            text: qsTr("mpv output:")
          }
          MochiComboBox {
            model: app.player.debugLevels
            currentIndex: app.player.debugLevels.indexOf(conf.player.debug)
            //onCurrentIndexChanged
          }
          Item { height: MochiStyle.spacing.margin }
          MochiCheckBox {
            text: qsTr("Clear output on new file")
//            checked:
          }
          Item { height: MochiStyle.spacing.margin }
          MochiText {
            text: qsTr("Can be viewed by showing the command line.")
          }
        }
      }
      MochiGroupBox {
        Layout.alignment: Qt.AlignTop | Qt.AlignLeft
        text: qsTr("Mouse/Touch Gestures")

        ColumnLayout {
          MochiCheckBox {
            text: qsTr("Use Gestures")
//            checked:
          }
          MochiText {
            text: qsTr("Tap and drag horizontally to seek.<br>Tap and drag vertically to control volume.")
          }
        }
      }
    }
    MochiGroupBox {
      text: qsTr("mpv.conf")
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft

      ColumnLayout {
        RowLayout {
          Layout.fillWidth: true

          MochiCheckBox {
            text: qsTr("Use mpv.conf file")
//            checked:
          }
          MochiTextButton {
            text: qsTr("Edit File")
//            onClicked:
          }
        }
        MochiText {
          text: qsTr("mochi-player honors your mpv.conf except some values that it overrides itself.<br>Please see mpv DOCS for a list of commands.")
        }
      }
    }
  }
}
