import QtQuick 2.7
import QtQuick.Layouts 1.3
import "."

Column {
  id: col

  property var view

  Repeater {
    model: view.count
    Rectangle {
      width: col.width
      height: col.height / view.count
      color: (view.currentIndex == index) ? MochiStyle.color.primary : MochiStyle.background.normal
      border.width: 1

      MochiTextButton {
        anchors.centerIn: parent
        text: view.getTab(index).title
        onClicked: view.currentIndex = index
      }
    }
  }
}
