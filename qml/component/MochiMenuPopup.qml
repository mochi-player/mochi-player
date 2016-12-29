import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../widget"

Popup {
  objectName: "menu"

  function _track_name(track) {
    return "%0 (%1%2)"
      .arg(track["title"] || track["decoder-desc"] || track["external-filename"])
      .arg(track["lang"])
      .arg(track["external"] ? "*" : "");
  }

  ColumnLayout {
    id: menuBody
    CheckBox {
      text: qsTr("Full Screen")

      checked: window.fullscreen
      onCheckedChanged: window.fullscreen = checked
      Connections {
          target: window
          onFullscreenChanged: checked = window.fullscreen
      }
    }
    CheckBox {
      text: qsTr("Dim Desktop")

      checked: window.dimDialog
      onCheckedChanged: window.dimDialog = checked
      Connections {
          target: window
          onFullscreenChanged: checked = window.dimDialog
      }
    }
    CheckBox {
      text: qsTr("Show CMD Line")

      checked: window.showCmdLine
      onCheckedChanged: window.showCmdLine = checked
      Connections {
          target: window
          onFullscreenChanged: checked = window.showCmdLine
      }
    }
    RowLayout {
      Layout.fillWidth: true
      Label {
        text: qsTr("On Top:")
      }
      ComboBox {
        Layout.fillWidth: true
        model: [qsTr("Always"), qsTr("When Playing"), qsTr("Never")]
        // TODO connect
      }
    }
    MochiSeparator { Layout.fillWidth: true }
    RowLayout {
      Layout.fillWidth: true

      CheckBox { // TODO: is this necessary? TODO Implement
        text: qsTr("Video")
        checked: player.vid != -1
        enabled: false
      }
      ComboBox {
        Layout.fillWidth: true
        model: player.videoTracks.map(_track_name)
        enabled: model.length > 1

        currentIndex: player.vid-1
        onCurrentIndexChanged: player.vid = currentIndex+1
        Connections {
            target: player
            onSidChanged: currentIndex = player.vid-1
        }
      }
      Button { // TODO
        Image {
          anchors.centerIn: parent
          source: "qrc:/add.svg"
        }
        enabled: false
//          onClicked: player.addVideo(app.openFileDialog("", app.videoFiletypes))
      }
    }
    RowLayout {
      Layout.fillWidth: true

      CheckBox { // TODO: is this necessary?
        id: aidCheckbox
        text: qsTr("Audio")
        enabled: player.audioTracks.length

        checked: !player.mute
        onCheckedChanged: player.mute = !checked
        Connections {
            target: player
            onSidChanged: checked = !player.mute
        }
      }
      ComboBox {
        Layout.fillWidth: true
        model: player.audioTracks.map(_track_name)
        enabled: model.length > 1 && !player.mute

        currentIndex: player.aid-1
        onCurrentIndexChanged: player.aid = currentIndex+1
        Connections {
            target: player
            onSidChanged: currentIndex = player.aid-1
        }
      }
      Button { // TODO
        Image {
          anchors.centerIn: parent
          source: "qrc:/add.svg"
        }
        enabled: false
//          onClicked: player.addAudio(app.openFileDialog("", app.audioFiletypes))
      }
    }
    RowLayout {
      Layout.fillWidth: true

      CheckBox {
        text: qsTr("Subtitles")
        enabled: player.subtitleTracks.length

        checked: player.subs
        onCheckedChanged: player.subs = checked
        Connections {
            target: player
            onSidChanged: checked = player.subs
        }
      }
      ComboBox {
        Layout.fillWidth: true
        model: player.subtitleTracks.map(_track_name)
        enabled: model.length > 1 && player.subs

        currentIndex: player.sid-1
        onCurrentIndexChanged: player.sid = currentIndex+1
        Connections {
            target: player
            onSidChanged: currentIndex = player.sid-1
        }
      }
      Button {
        Image {
          anchors.centerIn: parent
          source: "qrc:/add.svg"
        }
        onClicked: player.addSubtitle(app.openFileDialog("", app.subtitleFiletypes))
      }
    }
    RowLayout {
      Layout.fillWidth: true

      Label {
        text: "Speed"
      }
      Button {
        Image {
          anchors.centerIn: parent
          source: "qrc:/reset.svg"
        }
        onClicked: player.speed = 1.0
      }
      Item { Layout.fillWidth: true }
      Label {
        text: "x%0".arg(player.speed.toFixed(1))
      }
      Item { Layout.fillWidth: true }
      Button {
        Image {
          anchors.centerIn: parent
          source: "qrc:/remove.svg"
          scale: 0.5
        }
        onClicked: player.speed -= 0.1
      }
      Button {
        Image {
          anchors.centerIn: parent
          source: "qrc:/add.svg"
        }
        onClicked: player.speed += 0.1
      }
    }
    Button {
      Layout.fillWidth: true
      text: "Take Screenshot..."
      onClicked: {
        window.snapshotMode = true;
        close();
      }
    }
    MochiSeparator { Layout.fillWidth: true }
    RowLayout {
      Layout.fillWidth: true
      Button {
        Layout.fillWidth: true
        text: "Preferences..."
        onClicked: window.preferences()
      }
      Button {
        text: "?"
        onClicked: window.about()
      }
    }

  }
}
