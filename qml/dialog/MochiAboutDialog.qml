import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../widget"

MochiDialog {
  title: qsTr("About Mochi-Player")
  width: 400
  height: 200

  ColumnLayout {
    anchors.fill: parent

    RowLayout {
      Layout.fillWidth: true
      Image {
        sourceSize.height: 40
        source: "qrc:/logo.svg"
      }
      Column {
        Layout.fillHeight: true
        MochiText {
          text: "Mochi-Player"
          font.pointSize: MochiStyle.font.size*2
        }
        MochiText {
          text: qsTr("Version %0").arg(app.version)
        }
      }
    }
    MochiTextArea {
      Layout.fillWidth: true
      Layout.fillHeight: true
      text: qsTr("blahblahblah")
    }
    RowLayout {
      Layout.fillWidth: true
      spacing: MochiStyle.spacing.margin

      Item { Layout.fillWidth: true }
      MochiTextButton {
        text: qsTr("Update Streaming Support")
//        onClicked: update.updateYoutubeDl()
      }

      MochiTextButton {
        text: qsTr("Close")
        onClicked: close()
      }
    }
  }
}
