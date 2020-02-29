import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import FitWindow 1.0

ApplicationWindow {
  id: window
  title: 'fit window test'
  width: 500
  height: 500
  visible: true

  Item {
    anchors.fill: parent

    Rectangle {
      id: player

      anchors.centerIn: parent

      property var video_params: ({
        w: 1980,
        h: 1200,
        dw: player.width,
        dh: player.height,
      })

      color: 'black'
      anchors.fill: parent
      anchors.leftMargin: 10
      anchors.rightMargin: 100
      anchors.bottomMargin: 50
    }

    Action {
      shortcut: '0'
      onTriggered: _fit(0)
    }
    Action {
      shortcut: '1'
      onTriggered: _fit(0.25)
    }
    Action {
      shortcut: '2'
      onTriggered: _fit(0.5)
    }
    Action {
      shortcut: '3'
      onTriggered: _fit(0.75)
    }
    Action {
      shortcut: '4'
      onTriggered: _fit(1)
    }
    Action {
      shortcut: '5'
      onTriggered: _fit(1.25)
    }
    Action {
      shortcut: '6'
      onTriggered: _fit(1.5)
    }
    Action {
      shortcut: '7'
      onTriggered: _fit(1.75)
    }
    Action {
      shortcut: '8'
      onTriggered: _fit(2)
    }
  }

  function _fit(percent) {
    var geometry = FitWindow.fit({
      video_geometry: Qt.rect(
        0, 0,
        player.video_params.w, player.video_params.h,
      ),
      display_geometry: Qt.rect(
        0, 0,
        player.video_params.dw, player.video_params.dh,
      ),
      window_geometry: Qt.rect(
        0, 0,
        window.width, window.height,
      ),
      screen_geometry: Qt.rect(
        Screen.virtualX + 25, Screen.virtualY + 25,
        Screen.width - 25, Screen.height - 35,
      ),
      percent: percent,
    })
    window.x = geometry.x
    window.y = geometry.y
    window.width = geometry.width
    window.height = geometry.height

    console.log(`${player.video_params.dw / player.video_params.dh} ~> ${player.video_params.w / player.video_params.h}`)
  }
}
