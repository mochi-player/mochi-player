import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import Mochi 1.0 as Mochi
import "../style"
import "../widget"
import "../dialog"

ApplicationWindow {
  id: window
  objectName: "window"

  property var app: parent
  property string icon: ":/logo.svg"
  property bool fullscreen: false
  property bool dimDialog: false
  property bool showCmdLine: true
  property bool snapshotMode: false
  property bool playlistVisible: false

  property alias menu: menu
  property alias input: input
  property alias player: player
  property alias recent: recent
  property alias playlist: playlist
  property alias terminal: terminal
  property alias panel: panel
  property alias showTerminal: terminal.visible

  minimumWidth: 550
  minimumHeight: 400
  onClosing: if(app) app.quit()
  onFullscreenChanged: {
    if(fullscreen)
      window.showFullScreen();
    else
      window.showNormal();
  }

  Material.foreground: Style.color.foreground
  Material.background: Style.color.background
  Material.accent: Style.color.accent
  Material.primary: Style.color.primary
  font.family: Style.font.normal
  font.pointSize: Style.font.size

  MochiInput {
    id: input
    anchors.fill: parent

    Rectangle {
      anchors.fill: parent
      color: Material.background

      ColumnLayout {
        anchors.fill: parent

        SplitView {
          orientation: Qt.Horizontal
          handleDelegate: Rectangle {
            color: Material.primary
            width: 1
          }
          Layout.fillWidth: true
          Layout.fillHeight: true

          SplitView {
            orientation: Qt.Vertical
            handleDelegate: Rectangle {
              color: Material.primary
              height: 1
            }
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
              Layout.fillWidth: true
              Layout.fillHeight: true

              MochiPlayer {
                id: player
                anchors.fill: parent
              }
            }

            MochiTerminal {
              id: terminal
              Layout.fillWidth: true
              height: 200
              visible: showCmdLine
            }
          }
          MochiPlaylist {
            id: playlist

            Layout.fillHeight: true
            width: 100
          }
        }

        MochiSeekbar {
          Layout.fillWidth: true
          height: 5
          pos: player.pos ? (player.pos / 100.0) : 0
          ticks: player.chapters.map(function(ch) { return ch.time / player.duration; });
          onUpdatePos: function(pos) {
            player.seek(pos * player.duration, true);
          }
        }

        MochiPanel {
          id: panel
          Layout.fillWidth: true
          height: 25
        }
        Item { height: 1 }
      }
    }
    MochiMenuPopup {
      id: menu
      x: window.width - menu.width - 60
      y: window.height - panel.height - menu.height - 10
      visible: false
    }
  }

  DropArea {
    anchors.fill: parent
    onEntered: function(event) {
      if(event.hasUrls || event.hasText)
        event.accepted = true;
      else
        event.accepted = false;
    }
    onDropped: function(event) {
      if(event.hasUrls) {
        player.load(event.urls);
        event.accepted = true;
      }
      else if(event.hasText) {
        player.load(event.text);
        event.accepted = true;
      }
      else
        event.accepted = false;
    }
  }

  MochiRecent {
    id: recent
  }

  // Public methods
  function open() { _createDialog("MochiOpenDialog"); }
  function openLocation() { _createDialog("MochiOpenLocationDialog"); }
  function jump() { _createDialog("MochiJumpDialog"); }
  function dim() { _createDialog("MochiDimDialog"); }
  function preferences() { _createDialog("MochiPreferencesDialog"); }
  function about() { _createDialog("MochiAboutDialog"); }
  function onlineHelp() { Qt.openUrlExternally(app.url); }

  function fit(percent) {
    app.fit(window,
            player.parent.childrenRect,
            Qt.rect(0, 0, player.vWidth, player.vHeight),
            percent || 0);
  }

  // Private members
  property var _dialogs: new Object({})
  function _createDialog(file) {
    // Allocate dialogs as necessary
    if(file in _dialogs)
      _dialogs[file].visible = true;
    else {
      var dialog = Qt.createComponent('../dialog/%0.qml'.arg(file), window);
      if(dialog.status == Component.Ready)
        _dialogs[file] = dialog.createObject(window);
      else
        dialog.statusChanged.connect(function() {
          if(dialog.status == Component.Ready)
            _dialogs[file] = dialog.createObject(window);
          else if(dialog.status == Component.Error)
            console.log("Error loading component: ", dialog.errorString());
        });
    }
  }
}
