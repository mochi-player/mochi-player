import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "."

SpinBox {
  id: spin

  font.family: MochiStyle.font.normal
  font.pointSize: MochiStyle.font.size

  style: SpinBoxStyle {
    background: Rectangle {
      implicitHeight: Math.max(25, Math.round(styleData.contentHeight))
      implicitWidth: styleData.contentWidth + padding.left + padding.right
      color: MochiStyle.color.background_light
    }
    incrementControl: Image {
      anchors.centerIn: parent
      anchors.verticalCenterOffset: -1
      anchors.horizontalCenterOffset: -5
      source: "qrc:/triangle.svg"
      rotation: 180
      scale: 0.75
    }
    decrementControl: Image {
      anchors.centerIn: parent
      anchors.verticalCenterOffset: 1
      anchors.horizontalCenterOffset: -5
      source: "qrc:/triangle.svg"
      scale: 0.75
    }

    textColor: MochiStyle.color.text
  }
}
