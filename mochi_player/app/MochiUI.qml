import QtQuick 2.0
import QtQuick.Layouts 1.4
import QtQuick.Controls 1.4

Rectangle {
  id: self

  property QtObject state
  property QtObject action

  color: self.state.ui.style.color.background

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

          visible: self.state.ui.terminal.visible
        }
      }

      MochiPlaylist {
        id: playlist
        state: self.state
        action: self.action

        Layout.fillHeight: true
        width: 200

        visible: self.state.ui.playlist.visible
      }
    }

    MochiSeekbar {
      id: seekbar

      state: self.state
      action: self.action

      Layout.fillWidth: true

      visible: self.state.ui.seekbar.visible
    }

    MochiPanel {
      id: panel
      state: self.state
      action: self.action

      Layout.fillWidth: true
      height: 45

      visible: self.state.ui.panel.visible
    }
  }

  MochiMenuPopup {
    id: menu

    state: self.state
    action: self.action

    x: self.width - menu.width - 60
    y: self.height - panel.height - menu.height - 10
    visible: self.state.ui.menu.visible
  }

  MochiDropArea {
    id: dropArea
    state: self.state
    action: self.action

    anchors.fill: parent
  }

  Connections {
    target: self.action.ui

    onToggleMenu: self.state.ui.menu.visible = !self.state.ui.menu.visible
    onTogglePlaylist: self.state.ui.playlist.visible = !self.state.ui.playlist.visible
    onToggleTerminal: self.state.ui.terminal.visible = !self.state.ui.terminal.visible
    onToggleSnapshotMode: self.state.ui.snapshotMode.visible = !self.state.ui.snapshotMode.visible
  }
}
