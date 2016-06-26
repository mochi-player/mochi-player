import QtQuick 2.7
import "."

Item {
  id: seekbar
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
    height: seekbar.height
    color: MochiStyle.background.hard
    width: _safe(pos) * seekbar.width
  }

  Rectangle {
    x: incompleteRect.width
    y: 0
    height: seekbar.height
    color: MochiStyle.background.soft
    width: (1 - _safe(pos)) * seekbar.width
  }

  Repeater {
    id: ticks
    Rectangle {
      color: MochiStyle.seekbar.ticks
      width: MochiStyle.seekbar.tickWidth
      height: seekbar.height
      y: 0
      x: _safe(modelData) * seekbar.width
    }
  }

  MouseArea {
    anchors.fill: parent
    propagateComposedEvents: true

    Component.onCompleted: {
      var update = function(event) {
        parent.updatePos(parent._safe(event.x / seekbar.width));
        event.accept = true;
      };
      positionChanged.connect(update);
      clicked.connect(update);
    }
  }
}
