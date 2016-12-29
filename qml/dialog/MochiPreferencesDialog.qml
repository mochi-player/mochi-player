import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../widget"

Dialog {
  title: qsTr("Mochi-Player Preferences")

  width: 775
  height: 550

  onVisibleChanged: {
    if(visible)
      config.load()
    else
      config.save()
  }

  RowLayout {
    anchors.fill: parent
    ColumnLayout {
      Layout.fillHeight: true
      width: 100

      Repeater {
        model: [
          qsTr("Interface"),
          qsTr("Remote"),
          qsTr("Shortcuts"),
          qsTr("Video"),
          qsTr("Subtitles"),
          qsTr("Advanced")
        ]
        Rectangle {
          width: parent.width
          Layout.fillHeight: true
          color: (view.currentIndex == index) ? Material.accent : Material.background
          border.width: 1
          border.color: Material.primary
          Label {
            text: modelData
            anchors.centerIn: parent
          }
          MouseArea {
            cursorShape: Qt.PointingHandCursor
            anchors.fill: parent
            onClicked: view.currentIndex = index
          }
        }
      }
    }
    StackLayout {
      id: view
      Layout.fillWidth: true
      Layout.fillHeight: true

      MochiPreferencesInterface {
        Layout.fillWidth: true
        Layout.fillHeight: true
      }
      MochiPreferencesRemote {
        Layout.fillWidth: true
        Layout.fillHeight: true
      }
      MochiPreferencesShortcuts {
        Layout.fillWidth: true
        Layout.fillHeight: true
      }
      MochiPreferencesVideo {
        Layout.fillWidth: true
        Layout.fillHeight: true
      }
      MochiPreferencesSubtitles {
        Layout.fillWidth: true
        Layout.fillHeight: true
      }
      MochiPreferencesAdvanced {
        Layout.fillWidth: true
        Layout.fillHeight: true
      }
    }
  }
}
