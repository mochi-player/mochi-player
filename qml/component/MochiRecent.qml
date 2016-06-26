import QtQuick 2.7
import QtQuick.Controls 1.4
import Mochi 1.0 as Mochi

Menu {
  Repeater {
    model: Mochi.Recent {
      max: 20
      recent: []
      resume: true
    }
    MenuItem {
      text: title
      onTriggered: player.load(path)
      //            enabled: app.fileExists(path)
    }
  }
}
