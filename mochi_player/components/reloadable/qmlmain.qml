import QtQuick 2.7
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.11
import PyMain 1.0

Item {
  property string a
  property string b: main.b + '!'

  anchors.fill: parent

  PyMain {
    id: main
  }

  Text {
    anchors.centerIn: parent
    text: a + ' ' + b
  }
}