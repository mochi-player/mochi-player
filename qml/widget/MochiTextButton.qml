import QtQuick 2.7
import "."

MochiText {
  property bool enabled: true
  signal clicked(var event)

  font.family: MochiStyle.font.normal
  font.pointSize: MochiStyle.font.size
  font.weight: Font.Bold

  MouseArea {
    anchors.fill: parent
    propagateComposedEvents: true
    cursorShape: Qt.PointingHandCursor
    onClicked: function(event) {
      if(enabled) {
        parent.clicked(event);
        event.accept = true;
      }
      else
        event.accept = false;
    }
  }
}
