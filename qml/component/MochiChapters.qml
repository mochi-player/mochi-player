import QtQuick 2.7
import "../widget"

MochiListView {
  id: listView
  list: player.chapters
  listPos: player.chapter
  onListPosChanged: player.chapter = listView.listPos;
  Connections {
    target: player
    onChapterChanged: if(listView.length > 0) { listView.listPos = player.chapter; }
  }
}
