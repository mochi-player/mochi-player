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
      id: fullscreenCheckbox
      text: qsTr("Full Screen")

      TwoWayBinding {
        leftItem: fullscreenCheckbox
        rightItem: window
        leftProp: 'checked'
        rightProp: 'fullscreen'
      }
    }
    CheckBox {
      id: dimCheckbox
      text: qsTr("Dim Desktop")

      TwoWayBinding {
        leftItem: dimCheckbox
        rightItem: window
        leftProp: 'checked'
        rightProp: 'dimDialog'
      }
    }
    CheckBox {
      id: showCmdLineCheckbox
      text: qsTr("Show CMD Line")

      TwoWayBinding {
        leftItem: showCmdLineCheckbox
        rightItem: window
        leftProp: 'checked'
        rightProp: 'showCmdLine'
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
        id: vidCombo
        Layout.fillWidth: true
        model: player.videoTracks.map(_track_name)
        enabled: model.length > 1

        TwoWayBinding {
          leftItem: vidCombo
          rightItem: player
          leftProp: 'currentIndex'
          rightProp: 'vid'
          leftVal: vidCombo.currentIndex + 1
          rightVal: player.vid - 1
          enabled: vidCombo.enabled
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

        TwoWayBinding {
          leftItem: aidCheckbox
          rightItem: player
          leftProp: 'checked'
          rightProp: 'mute'
          leftVal: !aidCheckbox.checked
          rightVal: !player.mute
          enabled: aidCheckbox.enabled
        }
      }
      ComboBox {
        id: aidCombo
        Layout.fillWidth: true
        model: player.audioTracks.map(_track_name)
        enabled: model.length > 1 && !player.mute

        TwoWayBinding {
          leftItem: aidCombo
          rightItem: player
          leftProp: 'currentIndex'
          rightProp: 'aid'
          leftVal: aidCombo.currentIndex + 1
          rightVal: player.aid - 1
          enabled: aidCombo.enabled
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
        id: sidCheckbox
        text: qsTr("Subtitles")
        enabled: player.subtitleTracks.length

        TwoWayBinding {
          leftItem: sidCheckbox
          rightItem: player
          leftProp: 'checked'
          rightProp: 'subs'
          enabled: sidCheckbox.enabled
        }
      }
      ComboBox {
        id: sidCombo
        Layout.fillWidth: true
        model: player.subtitleTracks.map(_track_name)
        enabled: model.length > 1 && player.subs

        TwoWayBinding {
          leftItem: sidCombo
          rightItem: player
          leftProp: 'currentIndex'
          rightProp: 'sid'
          leftVal: sidCombo.currentIndex + 1
          rightVal: player.sid - 1
          enabled: sidCombo.enabled
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
        text: qsTr("Speed")
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
      text: qsTr("Take Screenshot...")
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
        text: qsTr("Preferences...")
        onClicked: window.preferences()
      }
      Button {
        text: qsTr("?")
        onClicked: window.about()
      }
    }
  }
}
