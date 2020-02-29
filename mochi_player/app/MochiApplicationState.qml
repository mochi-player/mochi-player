import QtQuick 2.0

QtObject {
  id: self

  property QtObject window: QtObject {
    property string title: "Mochi-Player: The tasty mpv based media player"
    property int width: 400
    property int height: 400
    property bool visible: true
  }

  property QtObject tray: QtObject {
    property bool visible: true
  }

  property QtObject input: QtObject {
    property var shortcuts: []
  }
}
