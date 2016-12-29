pragma Singleton
import QtQuick 2.7

QtObject {
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

  property QtObject seekbar: QtObject {
    property color ticks: "#ffffff"
    property int tickWidth: 1
  }
}
