import QtQuick 2.7
import "../widget"

MochiListView {
  id: listView
  list: player.chapters

  TwoWayBinding {
    leftItem: listView
    rightItem: player
    leftProp: 'listPos'
    rightProp: 'chapter'
  }
}
