import QtQuick 2.0
import QtQuick.Layouts 1.4
import QtQuick.Controls 1.4

Item {
  id: self

  property QtObject state
  property QtObject action

  ColumnLayout {
    anchors.fill: parent

    SplitView {
      orientation: Qt.Horizontal

      Layout.fillWidth: true
      Layout.fillHeight: true

      SplitView {
        orientation: Qt.Vertical

        Layout.fillWidth: true
        Layout.fillHeight: true

        MochiPlayer {
          id: player
          state: self.state
          action: self.action

          Layout.fillWidth: true
          Layout.fillHeight: true

          MochiGestureArea {
            id: gestureArea
            state: self.state
            action: self.action

            anchors.fill: player
          }
        }

        MochiTerminal {
          id: terminal
          state: self.state
          action: self.action

          Layout.fillWidth: true
          height: 200
        }
      }

      MochiPlaylist {
        id: playlist
        state: self.state
        action: self.action

        width: 200
        Layout.fillHeight: true
      }
    }

    MochiPanel {
      id: panel
      state: self.state
      action: self.action

      Layout.fillWidth: true
      height: 45
    }
  }

  MochiDropArea {
    id: dropArea
    state: self.state
    action: self.action

    anchors.fill: parent
  }
}
