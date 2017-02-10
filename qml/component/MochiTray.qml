import QtQuick 2.7
import Qt.labs.platform 1.0

SystemTrayIcon {
  iconSource: "qrc:/logo.svg"

  onActivated: {
      window.show()
      window.raise()
      window.requestActivate()
  }
  menu: Menu {
      MenuItem {
          text: qsTr("Quit")
          onTriggered: Qt.quit()
      }
  }
}
