import QtQuick 2.7
import QtQuick.Controls 2.5

ApplicationWindow {
  id: self
  title: {
    if (main.item && main.item.b) {
      return 'reloadable test ' + main.item.b
    } else {
      return 'reloadable test'
    }
  }
  width: 500
  height: 500
  visible: true

  Reloadable {
    id: main
    anchors.fill: parent
    source: Qt.resolvedUrl("qmlmain.qml")
    module: Qt.resolvedUrl('pymain.py')
  }
}
