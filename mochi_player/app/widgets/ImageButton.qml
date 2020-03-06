import QtQuick 2.7

Image {
  id: img
  property bool enabled: true
  signal clicked(var event)

  opacity: img.enabled ? 1.0 : 0.5

  MouseArea {
    anchors.fill: parent
    cursorShape: img.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
    propagateComposedEvents: true
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
    onClicked: function(event) {
      if(img.enabled) {
        parent.clicked(event);
        event.accept = true;
      }
      else
        event.accept = false;
    }
  }
}
