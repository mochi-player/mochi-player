import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "."

TabView {
  style: TabViewStyle {
    tab: Item {}
    frame: Rectangle {
      color: MochiStyle.background.normal
    }
  }
}
