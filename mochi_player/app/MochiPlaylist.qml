import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import "./widgets"

Rectangle {
  id: self

  property QtObject state
  property QtObject action

  property bool playlistShuffle: false
  property var playlist: self.state.player.playlist.map(function(e, i) {
    if (e.title === undefined) {
      e.title = e.filename;
    }
    return e;
  })
  onPlaylistChanged: console.log(self.playlist)

  property int indWidth: Math.min(
      (search.height / i.sourceSize.height) * i.sourceSize.width,
          t.boundingRect.width+state.ui.style.spacing.margin)

  TextMetrics {
    id: t
    font.family: state.ui.style.font.normal
    font.pointSize: state.ui.style.font.size
    text: playlistView.count
  }

  color: self.state.ui.style.color.background

  Image {
    id: i
    source: '../resources/img/play.svg'
    visible: false
  }

  Item {
    anchors.fill: self

    ColumnLayout {
      anchors.fill: parent
      spacing: 1

      TextField {
        id: search
        Layout.fillWidth: true
        placeholderText: qsTr("Search Playlist")
      }

      ListView {
        id: playlistView
        Layout.fillWidth: true
        Layout.fillHeight: true
        z: 1

        model: self.playlist.filter(function(e, i) {
          return String(i+1).indexOf(search.text) != -1 ||
                   e.title.indexOf(search.text) != -1;
        })
        delegate: Rectangle {
          anchors.left: parent.left
          anchors.right: parent.right
          height: search.height
          color: (index == playlistView.currentIndex) ? self.state.ui.style.color.primary : self.state.ui.style.color.background
          RowLayout {
            Layout.fillWidth: true
            height: parent.height
            Item {
              Layout.fillHeight: true
              Layout.alignment: Qt.AlignVCenter
              width: indWidth

              Image {
                anchors.centerIn: parent
                width: parent.width
                source: (index == self.state.player.playlistPos) ? '../resources/img/play.svg' : ''
                visible: index == self.state.player.playlistPos
              }
              Label {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: (index != self.state.player.playlistPos) ? index+1 : ''
                color: self.state.ui.style.color.foreground
                visible: index != self.state.player.playlistPos
              }
            }
            Label {
              Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
              Layout.fillWidth: true
              text: modelData.title
              color: self.state.ui.style.color.foreground
              font.weight: modelData.playing ? Font.Bold : Font.Normal
            }
//            Label {
//              text: modelData.duration
//            }
          }

          MouseArea {
            anchors.fill: parent
            onClicked: playlistView.currentIndex = index
            onDoubleClicked: self.state.player.playlistPos = index
          }
        }
      }
      Rectangle {
        Layout.fillWidth: true
        height: r.height
        color: self.state.ui.style.color.background

        ColumnLayout {
          id: r
          anchors.left: parent.left
          anchors.right: parent.right
          Rectangle { Layout.fillWidth: true; color: self.state.ui.style.color.accent; height: 1 }
          RowLayout {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignCenter

            ImageButton {
              source: "../resources/img/repeat_disabled.svg"
      //        TODO:
      //        source: {
      //          if(self.playlist.repeat == "")
      //            return "../resources/img/repeat_disabled.svg";
      //          else if(self.playlist.repeat == "once")
      //            return "../resources/img/repeat_once.svg";
      //          else if(self.playlist.repeat == "all")
      //            return "../resources/img/repeat_enabled.svg";
      //          return "";
      //        }
              //      onClicked: app.cycle(self.playlist.repeat)
            }
            Item { Layout.fillWidth: true }
            Label {
              text: (playlistView.currentIndex >= 0) ? "%0 / %1".arg(playlistView.currentIndex+1).arg(playlistView.count) : ""
            }
            Item { Layout.fillWidth: true }
            ImageButton {
              source: playlistShuffle ? "../resources/img/shuffle_enabled.svg" : "../resources/img/shuffle_enabled.svg"
              onClicked: playlistShuffle ^= true
            }
          }
        }
      }
    }
  }
}
