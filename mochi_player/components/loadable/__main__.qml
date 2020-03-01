import QtQuick 2.0
import QtQuick.Controls 2.5

ApplicationWindow {
  id: appwin
  title: 'loadable test ' + main.exports.b
  width: 500
  height: 500
  visible: true

  Loadable {
    id: main
    anchors.fill: parent

    source: Qt.resolvedUrl("qmlmain.qml")
    props: QtObject {
      property string a: 'Hello'
    }
    exports: QtObject {
      property string b
    }
  }
}