import QtQuick 2.7
import "../widget"

MochiListView {
  id: listView
  list: player.recent
  listPos: null
  onListPosChanged: {
    if(listPos !== null) {
      player.load(list[listPos]);
      listPos = null;
    }
  }
}
