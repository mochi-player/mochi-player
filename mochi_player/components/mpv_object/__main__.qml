import QtQuick 2.0
import QtQuick.Controls 2.5
import MpvObject 1.0

ApplicationWindow {
  title: 'mpv_object test'
  width: 500
  height: 500
  visible: true

  Item {
    anchors.fill: parent

    MpvObject {
      id: player
      anchors.fill: parent
      width: 0
      height: 0

      function load(paths) {
        if (typeof paths === 'object' && Array.isArray(paths)) {
          player.command(['loadfile', path[0].toString(), 'append-play'])
          for (const path of paths.slice(1)) {
            player.command(['loadfile', path.toString(), 'append'])
          }
        } else {
          player.command(['loadfile', paths.toString(), 'append-play'])
        }
      }
    }

    Rectangle {
      id: labelFrame
      anchors.margins: -50
      radius: 5
      color: "white"
      border.color: "black"
      opacity: 0.8
      anchors.fill: box
    }

    Row {
      id: box
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.margins: 100

      Text {
        anchors.margins: 10
        wrapMode: Text.WordWrap
        text: "QtQuick and mpv are both rendering stuff.\n
            In this example, mpv is always in the background.\n
            Drag file in to load"
      }

      Row {
        Button {
          anchors.margins: 10
          text: "Prev"
          onClicked: player.command(["cycle", "playlist-pos", "down"])
        }
        Button {
          anchors.margins: 10
          text: "PlayPause"
          onClicked: player.command(["cycle", "pause"])
        }
        Button {
          anchors.margins: 10
          text: "Next"
          onClicked: player.command(["cycle", "playlist-pos", "up"])
        }
      }
    }

    DropArea {
      anchors.fill: parent
      onEntered: function(event) {
        if(event.hasUrls || event.hasText)
          event.accepted = true;
        else
          event.accepted = false;
      }
      onDropped: function(event) {
        if(event.hasUrls) {
          console.log(event.urls)
          player.load(event.urls);
          event.accepted = true;
        }
        else if(event.hasText) {
          console.log(event.text)
          player.load(event.text);
          event.accepted = true;
        }
        else
          event.accepted = false;
      }
    }
  }
}
