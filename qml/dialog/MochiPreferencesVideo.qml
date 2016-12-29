import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../style"
import "../widget"

ColumnLayout {
  anchors.fill: parent

  RowLayout {
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft

    Label {
      text: qsTr('Video output:')
    }
    TextField {
      text: player.vo
      enabled: false
    }
  }
  Label {
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
    text: qsTr('In order for mochi-player to work correctly, the video output must be set to opengl-cb.')
  }
  Item { height: Style.spacing.margin }
  CheckBox {
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
    text: qsTr('Motion Interpolation')
  }
  Label {
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
    text: qsTr('Reduce stuttering caused by mismatches in the video fps and display refresh rate (also known as judder).')
  }
  Label {
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
    text: qsTr('Note: video-sync will be set to "display-vdrop" internally to enable interpolation')
  }
}
