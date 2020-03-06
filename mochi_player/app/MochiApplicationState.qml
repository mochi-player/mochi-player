import QtQuick 2.0

QtObject {
  id: self

  property QtObject window: QtObject {
    property string title: "Mochi-Player: The tasty mpv based media player"
    property int width: 400
    property int height: 400
    property bool fullscreen: true
    property bool visible: true
  }

  property QtObject ui: QtObject {
    property bool snapshotMode: false
    property bool dimLights: false

    property QtObject playlist: QtObject {
      property bool visible: true
    }
    property QtObject recent: QtObject {
      property bool visible: true
      property int max: 20
      property bool resume: true
      property var paths: []
    }
    property QtObject chapters: QtObject {
      property bool visible: true
    }
    property QtObject terminal: QtObject {
      property bool visible: true
    }
    property QtObject seekbar: QtObject {
      property bool visible: true
    }
    property QtObject panel: QtObject {
      property bool visible: true
    }
    property QtObject menu: QtObject {
      property bool visible: false
    }
    property QtObject style: QtObject {
      property QtObject font: QtObject {
        property string normal: "Noto Sans"
        property string code: "monospace"
        property double size: 10.0
      }

      property QtObject color: QtObject {
        property string theme: "Dark"
        property color foreground: "#f5f5f5"
        property color background: "#1a1a1a"
        property color accent: "#008098"
        property color primary: "#383838"
      }

      property QtObject spacing: QtObject {
        property int margin: 10
        property int top: 40
        property int bottom: 10
        property int side: 20
        property int padding: 5
      }
    }
  }

  property QtObject tray: QtObject {
    property bool visible: true
  }

  property QtObject player: QtObject {
    property var chapterList: []
    property int chapter: 0
    property int dheight: 0
    property double duration: 0
    property int dwidth: 0
    property string filename: ''
    property string mediaTitle: ''
    property bool mute: false
    property string path: ''
    property bool pause: true
    property int playlistPos: 0
    property var playlist: []
    property bool seeking: false
    property double speed: 1.0
    property double subScale: 1.0
    property bool subVisibility: true
    property double timePos: 0
    property var trackList: []
    property int volume: 50
  }

  property QtObject input: QtObject {
    property var keys: {
      ' ': 'action.player.playPause()',
    }
    property var mouse: {
      'wheelUp': 'action.player.adjustVolume(5)',
      'wheelDown': 'action.player.adjustVolume(-5)',
      'leftClick': undefined,
      'middleClick': undefined,
      'rightClick': 'action.player.playPause()',
      'leftDoubleClick': 'action.window.fullscreen()',
      'middleDoubleClick': undefined,
      'rightDoubleClick': undefined,
      'leftVDrag': 'function (val) { action.player.adjustVolume(-val * 100) }',
      'leftHDrag': 'function (val) { action.player.seekRelative(val * state.player.duration / 10) }',
    }
  }
}
