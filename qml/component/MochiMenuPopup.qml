import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../widget"

Rectangle {
  objectName: "menu"

  property var pos

  property var videoTracks: player.tracks.filter(function() { return this.type == "video"; })
  property var audioTracks: player.tracks.filter(function() { return this.type == "audio"; })
  property var subtitleTracks: player.tracks.filter(function() { return this.type == "sub"; })

  color: MochiStyle.background.normal
  width: menuBody.width
  height: menuBody.height + 10

  MochiBorder {
    id: border
    width: 1

    Image {
      source: "qrc:/triangle.svg"
      x: parent.x + parent.width - 20
      y: parent.y + parent.height

      height: 10
      width: 10
    }
  }
  ColumnLayout {
    id: menuBody
    MochiCheckBox {
      text: qsTr("Full Screen")
      checked: window.fullscreen
    }
    MochiCheckBox {
      text: qsTr("Dim Desktop")
      checked: window.dimDialog
    }
    MochiCheckBox {
      text: qsTr("Show CMD Line")
      checked: window.showCmdLine
    }
    MochiSeparator { Layout.fillWidth: true }
    RowLayout {
      Layout.fillWidth: true

      MochiCheckBox {
        id: vidCheckbox
        text: qsTr("Video")
        checked: player.vid != -1
        enabled: videoTracks.length
      }
      MochiComboBox {
        Layout.fillWidth: true
        model: videoTracks
//        currentText: player.vid
        enabled: vidCheckbox.enabled && vidCheckbox.checked
      }
    }
    RowLayout {
      Layout.fillWidth: true

      MochiCheckBox {
        id: aidCheckbox
        text: qsTr("Audio")
        checked: player.aid
        enabled: audioTracks.length
      }
      MochiComboBox {
        Layout.fillWidth: true
        model: audioTracks
//        currentText: player.aid
        enabled: aidCheckbox.enabled && aidCheckbox.checked
      }
    }
    RowLayout {
      Layout.fillWidth: true

      MochiCheckBox {
        id: sidCheckbox
        text: qsTr("Subtitles")
        checked: player.sid
        enabled: subtitleTracks.length
      }
      MochiComboBox {
        Layout.fillWidth: true
        model: subtitleTracks
//        currentText: player.sid
        enabled: sidCheckbox.enabled && sidCheckbox.checked
      }
      MochiTextButton {
        text: "+"
        onClicked: player.addSubtitle(app.openFileDialog("", app.subtitleFiletypes))
      }
    }
    RowLayout {
      Layout.fillWidth: true

      MochiText {
        text: "Speed"
      }
      MochiTextButton {
        text: "-"
        onClicked: player.speed += 0.1
      }
      MochiText {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignCenter
        text: "x%0".arg(player.speed)
      }
      MochiTextButton {
        text: "+"
        onClicked: player.speed -= 0.1
      }
    }
    MochiTextButton {
      Layout.fillWidth: true
      text: "Take Screenshot..."
      onClicked: player.screenshot.dialog ? window.screenshot() : player.screenshot()
    }
    MochiSeparator { Layout.fillWidth: true }
    MochiTextButton {
      Layout.fillWidth: true
      text: "Preferences..."
      onClicked: window.preferences()
    }
  }
}
