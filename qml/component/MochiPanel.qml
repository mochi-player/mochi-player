import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../widget"

Rectangle {
  property alias menuButton: menuButton

  color: Material.background

  RowLayout {
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

    Item { width: 5 }

    ImageButton {
      source: "qrc:/open.svg"
      onClicked: function(event) {
        if(event.button == Qt.LeftButton)
          window.open();
        else if(event.button == Qt.RightButton)
          window.openLocation();
        else if(event.button == Qt.MiddleButton)
          window.jump();
      }
    }

    Item { width: 5 }

    Label {
      // TODO: Why is app not available here?
      text: app ? app.serializeTime(player.pos, player.duration) : ""
    }

    // TODO: (Figure out why the below code doesn't work)
    //    Label {
    //      text: app.remaining ? " / -" : " / "
    //      visible: player.duration > 0
    //    }

    //    Button {
    //      text: app.remaining ? app.serializeTime(100.0 - player.pos, player.duration) : app.serializeTime(100.0, player.duration)
    //      font.weight: Font.Normal
    //      onClicked: app.remaining ^= true
    //    }
  }

  StackLayout {
    anchors.fill: parent
    currentIndex: window.snapshotMode
    Item {
      anchors.fill: parent
      ImageButton {
        id: playButton
        anchors.centerIn: parent
        source: (player.path == "" || player.pause) ? "qrc:/play.svg" : "qrc:/pause.svg"
        onClicked: player.pause ^= true
        enabled: player.path != ""
      }

      RowLayout {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: playButton.left

        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        spacing: 20

        ImageButton {
          source: "qrc:/reverse.svg"
          onClicked: player.pos = 0.0
          enabled: player.path != ""
        }
        ImageButton {
          source: "qrc:/previous.svg"
          onClicked: player.playlistPos -= 1
          enabled: player.playlist.length > 1 && player.playlistPos > 0
          Label {
            anchors.centerIn: parent
            text: player.playlistPos
            color: Material.accent
            visible: parent.enabled
          }
        }
        Item { width: 5 }
      }

      RowLayout {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: playButton.right

        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        spacing: 20

        Item { width: 5 }
        ImageButton {
          source: "qrc:/next.svg"
          onClicked: player.playlistPos += 1
          enabled: player.playlist.length > 1 && (player.playlist.length - player.playlistPos) > 1
          Label {
            anchors.centerIn: parent
            text: player.playlistPos+2
            color: Material.accent
            visible: parent.enabled
          }
        }
        ImageButton {
          source: player.mute ? "qrc:/volume_mute.svg" : "qrc:/volume_unmute.svg"
          onClicked: player.mute ^= true
        }
        MochiSlider {
          width: 100
          pos: player.volume / 100.0
          onUpdatePos: function(pos) { player.volume = pos * 100.0; }
        }
      }

      RowLayout {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        spacing: 20

        ImageButton {
          id: menuButton
          source: "qrc:/menu.svg"
          onClicked: menu.visible ^= true
        }
        ImageButton {
          source: "qrc:/playlist.svg"
          onClicked: window.playlistVisible ^= true
          enabled: player.playlist.length > 1
        }

        Item { width: 5 }
      }
    }
    Item {
      id: snapshotMode
      anchors.fill: parent

      ImageButton {
        id: captureButton
        anchors.centerIn: parent
        source: "qrc:/snapshot.svg"
        onClicked: player.screenshot()
      }

      RowLayout {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: captureButton.left

        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        spacing: 20

        ImageButton {
          source: "qrc:/subtitle.svg"
          opacity: player.subs ? 1.0 : 0.5
          onClicked: player.subs ^= true
        }
        ImageButton {
          source: "qrc:/reverse.svg"
          onClicked: player.frameBackStep()
        }
        Item { width: 5 }
      }

      RowLayout {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: captureButton.right

        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        spacing: 20

        Item { width: 5 }
        ImageButton {
          source: "qrc:/reverse.svg"
          onClicked: player.frameStep()
          rotation: 180
        }
        ImageButton {
          source: "qrc:/close.svg"
          onClicked: window.snapshotMode = false
        }
      }
    }
  }
}
