import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../widget"

Tab {
  property var conf
  title: qsTr('Video')

  ColumnLayout {
    anchors.fill: parent

    RowLayout {
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft

      MochiText {
        text: qsTr('Video output:')
      }
      MochiTextInput {
        text: conf.vo
        enabled: false
      }
    }
    MochiText {
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft
      text: qsTr('In order for mochi-player to work correctly, the video output must be set to opengl-cb.')
    }
    Item { height: MochiStyle.spacing.margin }
    MochiCheckBox {
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft
      text: qsTr('Motion Interpolation')
    }
    MochiText {
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft
      text: qsTr('Reduce stuttering caused by mismatches in the video fps and display refresh rate (also known as judder).')
    }
    MochiText {
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft
      text: qsTr('Note: video-sync will be set to "display-vdrop" internally to enable interpolation')
    }
  }
}
