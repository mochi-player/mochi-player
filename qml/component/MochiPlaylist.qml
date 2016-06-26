import QtQuick 2.7
import QtQuick.Layouts 1.3
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
          t.boundingRect.width+MochiStyle.spacing.margin)

  TextMetrics {
    id: t
    font.family: MochiStyle.font.normal
    font.pointSize: MochiStyle.font.size
    text: playlistView.count
  }

  Image {
    id: i
    source: 'qrc:/play.svg'
    visible: false
  }

  Rectangle {
    anchors.fill: parent
    color: MochiStyle.background.normal

    ColumnLayout {
      anchors.fill: parent
      spacing: 1

      MochiTextInput {
        id: search
        Layout.fillWidth: true
        background: MochiStyle.background.soft
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
          color: (index == playlistView.currentIndex) ? MochiStyle.background.accent : MochiStyle.background.normal
          RowLayout {
            Layout.fillWidth: true
            height: parent.height
            Item {
              Layout.fillHeight: true
              Layout.alignment: Qt.AlignVCenter
              width: indWidth

              Image {
                anchors.right: parent.right
                width: parent.width
                source: (index == player.playlistPos) ? 'qrc:/play.svg' : ''
                visible: index == player.playlistPos
              }
              MochiText {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: (index != player.playlistPos) ? index+1 : ''
                visible: index != player.playlistPos
              }
            }
            Text {
              Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
              Layout.fillWidth: true
              text: modelData.title
              color: MochiStyle.text.normal
              font.weight: modelData.playing ? Font.Bold : Font.Normal
            }
//            Text {
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
        color: MochiStyle.background.normal
        ColumnLayout {
          id: r
          anchors.left: parent.left
          anchors.right: parent.right
          MochiSeparator { Layout.fillWidth: true }
          RowLayout {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignCenter

            MochiButton {
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
            MochiText {
              text: (playlistView.currentIndex >= 0) ? "%0 / %1".arg(playlistView.currentIndex+1).arg(playlistView.count) : ""
            }
            Item { Layout.fillWidth: true }
            MochiButton {
              source: playlistShuffle ? "qrc:/shuffle_enabled.svg" : "qrc:/shuffle_enabled.svg"
              onClicked: playlistShuffle ^= true
            }
          }
        }
      }
    }
  }
}
