import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../style"
import "../widget"

ColumnLayout {
  RowLayout {
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft

    GroupBox {
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft
      title: qsTr("Command Line")

      ColumnLayout {
        Label {
          text: qsTr("mpv output:")
        }
        ComboBox {
          model: player.debugLevelsVerbose

          currentIndex: player.debugLevels.indexOf(player.debug)
          onCurrentIndexChanged: player.debug = player.debugLevels[currentIndex]
          Connections {
              target: player
              onDebugChanged: currentIndex = player.debugLevels.indexOf(player.debug)
          }
        }
        Item { height: Style.spacing.margin }
        CheckBox { // TODO
          text: qsTr("Clear output on new file")
        }
        Item { height: Style.spacing.margin }
        Label {
          text: qsTr("Can be viewed by showing the command line.")
        }
      }
    }
    GroupBox {
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft
      title: qsTr("Mouse/Touch Gestures")

      ColumnLayout {
        CheckBox {
          text: qsTr("Use Gestures")

          checked: inputs.gestures
          onCheckedChanged: inputs.gestures = checked
          Connections {
            target: inputs
            onGesturesChanged: checked = input.gestures
          }
        }
        Label {
          text: qsTr("Tap and drag horizontally to seek.<br>Tap and drag vertically to control volume.")
        }
      }
    }
  }
  GroupBox {
    title: qsTr("mpv.conf")
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft

    ColumnLayout {
      RowLayout {
        CheckBox { // TODO
          text: qsTr("Use mpv.conf file")
        }
        Button { // TODO
          text: qsTr("Edit File")
        }
      }
      Label {
        text: qsTr("mochi-player honors your mpv.conf except some values that it overrides itself.<br>Please see mpv DOCS for a list of commands.")
      }
    }
  }
}
