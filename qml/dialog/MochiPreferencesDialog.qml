import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../widget"

MochiDialog {
  property var conf// = Object.create(app)
  title: qsTr("Mochi-Player Preferences")

  width: 700
  height: 300

  RowLayout {
    anchors.fill: parent

    MochiTabBar {
      view: view
      width: 100
      Layout.fillHeight: true
    }

    MochiTabView {
      id: view
      Layout.fillWidth: true
      Layout.fillHeight: true

      MochiPreferencesInterface { conf: conf }
      MochiPreferencesRemote { conf: conf }
      MochiPreferencesShortcuts { conf: conf }
      MochiPreferencesVideo { conf: conf }
      MochiPreferencesSubtitles { conf: conf }
      MochiPreferencesAdvanced { conf: conf }
    }
  }
}
