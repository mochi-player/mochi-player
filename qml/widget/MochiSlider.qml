import QtQuick 2.7
import "."

Item {
  id: slider

  property double pos
  signal updatePos(double pos)

  function _safe(p) {
    return Math.max(0.0, Math.min(1.0, p));
  }

  width: 100
  height: 25

  Rectangle {
    id: incompleteRect
    x: 0
    y: slider.height/2 - height/2
    height: 2
    color: MochiStyle.background.hard
    width: _safe(pos) * slider.width
  }

  Rectangle {
    x: incompleteRect.width
    y: slider.height/2 - height/2
    height: 2
    color: MochiStyle.background.soft
    width: (1 - _safe(pos)) * slider.width
  }

  Image {
    source: "qrc:/circle.svg"
    x: (_safe(pos) * slider.width) - width/2
    y: slider.height/2 - height/2
    height: 10
    width: 10
  }

  MouseArea {
    anchors.fill: parent
    propagateComposedEvents: true

    Component.onCompleted: {
      var update = function(event) {
        parent.updatePos(parent._safe(event.x / slider.width));
        event.accept = true;
      };
      positionChanged.connect(update);
      clicked.connect(update);
    }
  }
}
