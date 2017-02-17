import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../style"
import "../widget"

ColumnLayout {
  property bool shuffle: false

  MochiListView {
    id: listView
    Layout.fillHeight: true
    Layout.fillWidth: true

    list: player.playlist
    listPos: player.playlistPos
    onListPosChanged: player.playlistPos = listView.listPos
    Connections {
      target: player
      onChapterChanged: if(listView.length > 0) { listView.listPos = player.playlistPos; }
    }
  }

  ColumnLayout {
    Layout.fillWidth: true

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
        text: (listView.currentIndex >= 0) ? "%0 / %1".arg(listView.currentIndex+1).arg(listView.count) : ""
      }
      Item { Layout.fillWidth: true }
      ImageButton {
        source: shuffle ? "qrc:/shuffle_enabled.svg" : "qrc:/shuffle_enabled.svg"
        onClicked: shuffle ^= true
      }
    }
  }
}
