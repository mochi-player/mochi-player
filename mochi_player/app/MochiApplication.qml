import QtQuick 2.0
import Qt.labs.platform 1.1 as Labs

MochiApplicationWindow {
  id: self

  state: state
  action: action

  MochiApplicationState {
    id: state
  }

  MochiApplicationAction {
    id: action
  }

  MochiUI {
    id: ui
    state: state
    action: action

    anchors.fill: parent
  }

  MochiInput {
    id: input
    state: state
    action: action
  }

  // TODO: Use a loader and only load if visible = true
  MochiSystemTray {
    id: tray
    state: state
    action: action
  }
}
