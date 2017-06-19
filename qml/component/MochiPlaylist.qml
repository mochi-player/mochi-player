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
    TwoWayBinding {
      leftItem: listView
      rightItem: player
      leftProp: 'listPos'
      rightProp: 'playlistPos'
      enabled: listView.list.length > 0
    }
  }

  ColumnLayout {
    Layout.fillWidth: true

    MochiSeparator { Layout.fillWidth: true }
    RowLayout {
      Layout.alignment: Qt.AlignVCenter | Qt.AlignCenter

      ImageButton {
        source: "qrc:/repeat_disabled.svg"
        sourceSize.width: 18
        sourceSize.height: 18
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
        sourceSize.width: 18
        sourceSize.height: 18
        onClicked: shuffle ^= true
      }
    }
  }
}
