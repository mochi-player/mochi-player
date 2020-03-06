import QtQuick 2.7
import QtQuick.Controls 1.4

Item {
  id: self

  property QtObject state
  property QtObject action

  Menu {
    Repeater {
      model: state.ui.recent.paths
      MenuItem {
        text: path
        onTriggered: action.player.load(path)
        // enabled: os.path.isfile(path)
      }
    }
  }
}
