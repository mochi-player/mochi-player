pragma Singleton
import QtQuick 2.7

QtObject {
  property QtObject font: QtObject {
    property double size: 12.0
    property string normal: "Noto Sans"
    property string code: "monospace"
  }

  property QtObject spacing: QtObject {
    property int margin: 10
    property int top: 40
    property int bottom: 10
    property int side: 20
    property int padding: 5
  }

  property QtObject color: QtObject {
    property color background: "#1a1a1a"
    property color background_light: "#383838"
    property color selection: "#383838"
    property color text_hint: "#979797"
    property color text: "#f5f5f5"
    property color primary: "#008098"
  }

  property QtObject background: QtObject {
    property color normal: "#1a1a1a"
    property color accent: "#383838"
    property color hard: "#008098"
    property color soft: "#383838"
    property color player: "#000000"
    property color invert: "#ffffff"
  }

  property QtObject text: QtObject {
    property color normal: "#f5f5f5"
    property color soft: "#979797"
    property color accent: "#f5f5f5"
  }

  property QtObject seekbar: QtObject {
    property color ticks: "#ffffff"
    property int tickWidth: 1
  }

  property int top: 1
  property int left: 2
  property int right: 3
  property int bottom: 4
}
