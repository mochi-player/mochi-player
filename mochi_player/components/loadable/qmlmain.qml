import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.11

Item {
  property string a
  property string b: '!'

  anchors.fill: parent

  Text {
    anchors.centerIn: parent
    text: a + ' ' + b
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      console.log('clicked', b)
      b = b + '!'
    }
  }
}