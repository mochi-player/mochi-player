import QtQuick 2.0
import Qt.labs.platform 1.1 as Labs

MochiApplicationWindow {
  id: window
  state: state

  MochiApplicationState {
    id: state
  }

  // TODO: Use a loader and only load if visible = true
  MochiSystemTray {
    id: tray
    state: state
  }
}
