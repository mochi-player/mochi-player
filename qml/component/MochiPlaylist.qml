import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../style"
import "../widget"

Item {
  property bool playlistShuffle: false
  property var playlist: player.playlist.map(function(e, i) {
    if(!e.title)
      e.title = e.filename;
    return e;
  });
  property int indWidth: Math.min(
      (search.height / i.sourceSize.height) * i.sourceSize.width,
          t.boundingRect.width+Style.spacing.margin)

  TextMetrics {
    id: t
    font.family: Style.font.normal
    font.pointSize: Style.font.size
    text: playlistView.count
  }

  Image {
    id: i
    source: 'qrc:/play.svg'
    visible: false
  }

  Rectangle {
    anchors.fill: parent
    color: Material.background

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
        z: -1

        model: playlist.filter(function(e, i) {
          return String(i+1).indexOf(search.text) != -1 ||
                   e.title.indexOf(search.text) != -1;
        })
        delegate: Rectangle {
          anchors.left: parent.left
          anchors.right: parent.right
          height: search.height
          color: (index == playlistView.currentIndex) ? Material.primary : Material.background
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
                source: (index == player.playlistPos) ? 'qrc:/play.svg' : ''
                visible: index == player.playlistPos
              }
              Label {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: (index != player.playlistPos) ? index+1 : ''
                visible: index != player.playlistPos
              }
            }
            Label {
              Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
              Layout.fillWidth: true
              text: modelData.title
              font.weight: modelData.playing ? Font.Bold : Font.Normal
            }
//            Label {
//              text: modelData.duration
//            }
          }

          MouseArea {
            anchors.fill: parent
            onClicked: playlistView.currentIndex = index
            onDoubleClicked: player.playlistPos = index
          }
        }
      }
      Rectangle {
        Layout.fillWidth: true
        height: r.height
        color: Material.background

        ColumnLayout {
          id: r
          anchors.left: parent.left
          anchors.right: parent.right
          MochiSeparator { Layout.fillWidth: true }
          RowLayout {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignCenter

            ImageButton {
              source: "qrc:/repeat_disabled.svg"
      //        TODO:
      //        source: {
      //          if(playlist.repeat == "")
      //            return "qrc:/repeat_disabled.svg";
      //          else if(playlist.repeat == "once")
      //            return "qrc:/repeat_once.svg";
      //          else if(playlist.repeat == "all")
      //            return "qrc:/repeat_enabled.svg";
      //          return "";
      //        }
              //      onClicked: app.cycle(playlist.repeat)
            }
            Item { Layout.fillWidth: true }
            Label {
              text: (playlistView.currentIndex >= 0) ? "%0 / %1".arg(playlistView.currentIndex+1).arg(playlistView.count) : ""
            }
            Item { Layout.fillWidth: true }
            ImageButton {
              source: playlistShuffle ? "qrc:/shuffle_enabled.svg" : "qrc:/shuffle_enabled.svg"
              onClicked: playlistShuffle ^= true
            }
          }
        }
      }
    }
  }
}
