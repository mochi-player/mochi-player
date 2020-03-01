import QtQuick 2.0
import QtQuick.Controls 2.5
import "../reloadable"

ApplicationWindow {
  title: 'seekbar test'
  width: 500
  height: 500
  visible: true

  Reloadable {
    anchors.fill: parent

    source: Qt.resolvedUrl("qmlmain.qml")
  }
}
