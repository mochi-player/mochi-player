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

  property QtObject player: QtObject {
    property int chapter: 0
    property int dheight: 0
    property double duration: 0
    property int dwidth: 0
    property string filename: ''
    property string mediaTitle: ''
    property bool mute: false
    property string path: ''
    property bool pause: true
    property bool seeking: false
    property double speed: 1.0
    property double timePos: 0
    property int volume: 50
  }
}
