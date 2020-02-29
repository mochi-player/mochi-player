import QtQuick 2.0
import QtQuick.Controls 2.5
import Qt.labs.platform 1.1 as Labs
import "../components/two_way_connection"

Item {
  id: self

  property QtObject state
  property QtObject action

  TwoWayConnection {
    left: tray; leftProp: 'visible'
    right: state.tray; rightProp: 'visible'
  }

  Connections {
    target: action.tray
    onShow: tray.show()
    onHide: tray.hide()
  }

  Labs.SystemTrayIcon {
    id: tray

    icon.source: Qt.resolvedUrl('../resources/img/logo.svg')

    menu: Labs.Menu {
      Labs.MenuItem {
        iconSource: Qt.resolvedUrl('../resources/img/previous.svg')
        text: qsTr("Previous")
        // onTriggered: TODO
      }
      Labs.MenuItem {
        iconSource: Qt.resolvedUrl('../resources/img/play.svg')
        text: qsTr("Play")
        // onTriggered: TODO
      }
      Labs.MenuItem {
        iconSource: Qt.resolvedUrl('../resources/img/stop.svg')
        text: qsTr("Stop")
        // onTriggered: TODO
      }
      Labs.MenuItem {
        iconSource: Qt.resolvedUrl('../resources/img/next.svg')
        text: qsTr("Next")
        // onTriggered: TODO
      }
      Labs.MenuSeparator {}
      Labs.MenuItem {
        iconSource: Qt.resolvedUrl('../resources/img/close.svg')
        text: qsTr("Quit")
        onTriggered: Qt.quit()
      }
    }

    onActivated: function (reason) {
      if (reason === Labs.SystemTrayIcon.Trigger) { // left click
        state.window.visible = true
      } else if (reason === Labs.SystemTrayIcon.MiddleClick) { // middle click
        // probably trigger pause
      } else if (reason === Labs.SystemTrayIcon.DoubleClick) { // double click
        state.window.visible = false
      }
    }

    Component.onCompleted: {
      if (state.tray.visible !== false) {
        tray.show()
      }
      tray.showMessage("Message title", "Something important came up. Click this to know more.")
    }
  }
}
