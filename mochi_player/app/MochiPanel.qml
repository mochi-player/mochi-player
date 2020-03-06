import QtQuick 2.7
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.0
import Utils 1.0
import "./widgets"

Rectangle {
  id: self

  property QtObject state
  property QtObject action

  color: self.state.ui.style.color.background

  RowLayout {
    anchors.fill: self

    Rectangle {
      property alias menuButton: menuButton
      Layout.fillWidth: true
      Layout.fillHeight: true

      color: self.state.ui.style.color.background

      RowLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

        Item { width: 5 }

        ImageButton {
          source: "../resources/img/open.svg"
          onClicked: function(event) {
            if(event.button == Qt.LeftButton)
              action.dialog.open();
            else if(event.button == Qt.RightButton)
              action.dialog.openLocation();
            else if(event.button == Qt.MiddleButton)
              action.dialog.jump();
          }
        }

        Item { width: 5 }

        Label {
          text: Utils.serializeTime(self.state.player.timePos, self.state.player.duration)
          color: self.state.ui.style.color.foreground
        }

        // TODO: (Figure out why the below code doesn't work)
        //    Label {
        //      text: app.remaining ? " / -" : " / "
        //      visible: self.state.player.duration > 0
        //    }

        //    Button {
        //      text: app.remaining ? Utils.serializeTime(100.0 - self.state.player.timePos, self.state.player.duration) : Utils.serializeTime(100.0, self.state.player.duration)
        //      font.weight: Font.Normal
        //      onClicked: app.remaining ^= true
        //    }
      }

      StackLayout {
        anchors.fill: parent
        currentIndex: self.state.ui.snapshotMode
        Item {
          Layout.fillWidth: true
          Layout.fillHeight: true

          RowLayout {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: playButton.left

            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            spacing: 20

            ImageButton {
              source: "../resources/img/reverse.svg"
              onClicked: self.action.player.seekAbsolute(0.0)
              enabled: self.state.player.path != ""
            }
            ImageButton {
              source: "../resources/img/previous.svg"
              onClicked: self.action.player.playPrev()
              enabled: self.state.player.playlistPos > 0
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
              source: "../resources/img/next.svg"
              onClicked: self.action.player.playNext()
              enabled: (self.state.player.playlist.length - self.state.player.playlistPos) < 1
            }
            ImageButton {
              source: self.state.player.mute ? "../resources/img/volume_mute.svg" : "../resources/img/volume_unmute.svg"
              onClicked: self.action.player.toggleMute()
            }
            Slider {
              width: 100
              pos: self.state.player.volume / 100.0
              onUpdatePos: function(pos) { self.action.player.adjustVolume((pos * 100.0) - self.state.player.volume) }
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
              source: "../resources/img/menu.svg"
              onClicked: action.ui.toggleMenu()
            }
            ImageButton {
              source: "../resources/img/playlist.svg"
              onClicked: action.ui.togglePlaylist()
              enabled: self.state.player.playlist.length > 1
            }

            Item { width: 5 }
          }

          ImageButton {
            id: playButton
            anchors.centerIn: parent
            source: (self.state.player.path == "" || self.state.player.pause) ? "../resources/img/play.svg" : "../resources/img/pause.svg"
            onClicked: self.action.player.playPause()
            enabled: self.state.player.path != ""
          }
        }
        Item {
          id: snapshotMode
          Layout.fillWidth: true
          Layout.fillHeight: true

          ImageButton {
            id: captureButton
            anchors.centerIn: parent
            source: "../resources/img/snapshot.svg"
            onClicked: self.action.player.takeScreenshot()
          }

          RowLayout {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: captureButton.left

            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            spacing: 20

            ImageButton {
              source: "../resources/img/subtitle.svg"
              opacity: player.subs ? 1.0 : 0.5
              onClicked: self.action.player.toggleSubtitles()
            }
            ImageButton {
              source: "../resources/img/reverse.svg"
              onClicked: self.action.player.frameBackStep()
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
              source: "../resources/img/reverse.svg"
              onClicked: self.action.player.frameStep()
              rotation: 180
            }
            ImageButton {
              source: "../resources/img/close.svg"
              onClicked: self.action.ui.toggleSnapshotMode()
            }
          }
        }
      }
    }
  }
}
