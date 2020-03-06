import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

SpinBox {
  id: self

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
  }

  font.family: self.style.font.normal
  font.pointSize: self.style.font.size

  style: SpinBoxStyle {
    background: Rectangle {
      implicitHeight: Math.max(25, Math.round(styleData.contentHeight))
      implicitWidth: styleData.contentWidth + padding.left + padding.right
      color: self.style.color.primary
    }
    incrementControl: Image {
      anchors.centerIn: parent
      anchors.verticalCenterOffset: -1
      anchors.horizontalCenterOffset: -5
      source: "../../resources/img/triangle.svg"
      rotation: 180
      scale: 0.75
    }
    decrementControl: Image {
      anchors.centerIn: parent
      anchors.verticalCenterOffset: 1
      anchors.horizontalCenterOffset: -5
      source: "../../resources/img/triangle.svg"
      scale: 0.75
    }

    textColor: self.style.color.foreground
  }
}
