import QtQuick 2.7

Item {
  id: self

  property QtObject style: QtObject {
    property int tickWidth: 1
    property color ticks: "#ffffff"

    property QtObject color: QtObject {
      property color accent: "#008098"
      property color primary: "#383838"
    }
  }

  property double pos
  property alias ticks: ticks.model
  signal updatePos(double pos)

  function _safe(p) {
    return Math.max(0.0, Math.min(1.0, p));
  }

  Rectangle {
    id: incompleteRect
    x: 0
    y: 0
    height: self.height
    color: self.style.color.accent
    width: _safe(pos) * self.width
  }

  Rectangle {
    x: incompleteRect.width
    y: 0
    height: self.height
    color: self.style.color.primary
    width: (1 - _safe(pos)) * self.width
  }

  Repeater {
    id: ticks
    Rectangle {
      color: self.style.ticks
      width: self.style.tickWidth
      height: self.height
      y: 0
      x: _safe(modelData) * self.width
    }
  }

  MouseArea {
    anchors.fill: parent
    propagateComposedEvents: true

    Component.onCompleted: {
      var update = function(event) {
        parent.updatePos(parent._safe(event.x / self.width));
        event.accept = true;
      };
      positionChanged.connect(update);
      clicked.connect(update);
    }
  }
}
