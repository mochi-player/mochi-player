import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import "./widgets"

Popup {
  id: self

  property QtObject state
  property QtObject action

  property var videoTracks: self.state.player.trackList.filter(function (track) { return track.type === 'video' })
  property var audioTracks: self.state.player.trackList.filter(function (track) { return track.type === 'audio' })
  property var subtitleTracks: self.state.player.trackList.filter(function (track) { return track.type === 'sub' })

  palette.window: self.state.ui.style.background
  palette.windowText: self.state.ui.style.foreground
  palette.brightText: self.state.ui.style.primary
  palette.highlightedText: self.state.ui.style.accent

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

      checked: self.state.window.fullscreen
      onCheckedChanged: self.action.window.toggleFullscreen()
    }
    CheckBox {
      text: qsTr("Dim Desktop")

      checked: self.state.window.dimLights
      onCheckedChanged: self.action.window.toggleDimLights()
    }
    CheckBox {
      text: qsTr("Show CMD Line")

      checked: self.state.ui.terminal.visible
      onCheckedChanged: self.action.ui.toggleTerminal()
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
    Rectangle { Layout.fillWidth: true; color: self.state.ui.style.color.accent; height: 1 }
    RowLayout {
      Layout.fillWidth: true

      CheckBox { // TODO: is this necessary? TODO Implement
        text: qsTr("Video")
        checked: self.state.player.vid != -1
        enabled: false
      }
      ComboBox {
        Layout.fillWidth: true
        model: self.videoTracks.map(_track_name)
        enabled: self.videoTracks.length > 1

        currentIndex: self.state.player.vid - 1
        onCurrentIndexChanged: self.action.player.setVideoId(currentIndex+1)
      }
      Button {
        Image {
          anchors.centerIn: parent
          source: "../resources/img/add.svg"
        }
        enabled: true
//          onClicked: self.state.player.addVideo(app.openFileDialog("", app.videoFiletypes))
      }
    }
    RowLayout {
      Layout.fillWidth: true

      CheckBox { // TODO: is this necessary?
        id: aidCheckbox
        text: qsTr("Audio")
        enabled: self.audioTracks.length

        checked: !self.state.player.mute
        onCheckedChanged: self.action.player.toggleMute()
      }
      ComboBox {
        Layout.fillWidth: true
        model: self.audioTracks.map(_track_name)
        enabled: self.audioTracks.length > 1 && !player.mute

        currentIndex: self.state.player.aid - 1
        onCurrentIndexChanged: self.action.player.setAudioId(currentIndex+1)
      }
      Button { // TODO
        Image {
          anchors.centerIn: parent
          source: "../resources/img/add.svg"
        }
        enabled: true
//          onClicked: player.addAudio(app.openFileDialog("", app.audioFiletypes))
      }
    }
    RowLayout {
      Layout.fillWidth: true

      CheckBox {
        text: qsTr("Subtitles")
        enabled: self.subtitleTracks.length

        checked: self.state.player.subVisibility
        onCheckedChanged: self.action.player.toggleSubtitles()
      }
      ComboBox {
        Layout.fillWidth: true
        model: self.subtitleTracks.map(_track_name)
        enabled: self.subtitleTracks.length > 1 && self.player.subVisibility

        currentIndex: self.state.player.sid-1
        onCurrentIndexChanged: self.action.player.setSubtitleId(currentIndex+1)
      }
      Button {
        Image {
          anchors.centerIn: parent
          source: "../resources/img/add.svg"
        }
        enabled: true
        // onClicked: self.action.player.addSubtitle(app.openFileDialog("", app.subtitleFiletypes))
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
          source: "../resources/img/reset.svg"
        }
        onClicked: self.action.player.setSpeed(1.0)
      }
      Item { Layout.fillWidth: true }
      Label {
        text: "x%0".arg(self.state.player.speed.toFixed(1))
      }
      Item { Layout.fillWidth: true }
      Button {
        Image {
          anchors.centerIn: parent
          source: "../resources/img/remove.svg"
          scale: 0.5
        }
        onClicked: self.action.player.setSpeed(self.state.player.speed - 0.1)
      }
      Button {
        Image {
          anchors.centerIn: parent
          source: "../resources/img/add.svg"
        }
        onClicked: self.action.player.setSpeed(self.state.player.speed + 0.1)
      }
    }
    Button {
      Layout.fillWidth: true
      text: "Take Screenshot..."
      onClicked: {
        self.action.ui.toggleSnapshotMode()
        close();
      }
    }
    Rectangle { Layout.fillWidth: true; color: self.state.ui.style.color.accent; height: 1 }
    RowLayout {
      Layout.fillWidth: true
      Button {
        Layout.fillWidth: true
        text: "Preferences..."
        onClicked: self.action.window.openPreferencesDialog()
      }
      Button {
        text: "?"
        onClicked: self.action.window.openAboutDialog()
      }
    }
  }
}
