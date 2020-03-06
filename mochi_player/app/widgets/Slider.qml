import QtQuick 2.7

Item {
  id: self

  property QtObject style: QtObject {
    property QtObject color: QtObject {
      property color accent: "#008098"
      property color primary: "#383838"
    }
  }

  property double pos
  signal updatePos(double pos)

  function _safe(p) {
    return Math.max(0.0, Math.min(1.0, p))
  }

  width: 100
  height: 25

  Rectangle {
    id: incompleteRect
    x: 0
    y: self.height/2 - height/2
    height: 2
    color: self.style.color.accent
    width: self._safe(self.pos) * self.width
  }

  Rectangle {
    x: incompleteRect.width
    y: self.height/2 - height/2
    height: 2
    color: self.style.color.primary
    width: (1 - self._safe(self.pos)) * self.width
  }

  Image {
    source: "../../resources/img/circle.svg"
    x: (self._safe(self.pos) * self.width) - width/2
    y: self.height/2 - height/2
    height: 10
    width: 10
  }

  MouseArea {
    id: mouseArea

    anchors.fill: parent
    propagateComposedEvents: true

    Component.onCompleted: {
      var update = function(event) {
        self.updatePos(self._safe(event.x / self.width))
        event.accept = true
      }
      mouseArea.positionChanged.connect(update)
      mouseArea.clicked.connect(update)
    }
  }
}
