import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import Mochi 1.0 as Mochi
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

//    menuBar: MochiMenu {
//      //      visible: !app.hideAllControls
//    }

  MochiInput {
    id: input
    anchors.fill: parent

    Rectangle {
      anchors.fill: parent
      color: MochiStyle.background.normal

      ColumnLayout {
        anchors.fill: parent

        SplitView {
          orientation: Qt.Horizontal
          handleDelegate: Rectangle {
            color: MochiStyle.background.accent
            width: 1
          }
          Layout.fillWidth: true
          Layout.fillHeight: true

          SplitView {
            orientation: Qt.Vertical
            handleDelegate: Rectangle {
              color: MochiStyle.background.accent
              height: 1
            }
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
              Layout.fillWidth: true
              Layout.fillHeight: true
              color: MochiStyle.background.player

              MochiPlayer {
                id: player
                anchors.fill: parent
                //                    visible: !app.hideAlbumArt
              }
            }

            MochiTerminal {
              id: terminal

              Layout.fillWidth: true
              height: 100
              visible: showCmdLine
            }
          }
          MochiPlaylist {
            id: playlist

            Layout.fillHeight: true
            width: 100
            //                visible: app.playlistVisible
          }
        }

        MochiSeekbar {
          Layout.fillWidth: true
          height: 5
          pos: player.pos / 100.0
          ticks: player.chapters.map(function(ch) { return ch.time / player.duration; });
          onUpdatePos: function(pos) {
            player.seek(pos * player.duration, true);
          }
          //            visible: !app.hideAllControls
        }

        MochiPanel {
          id: panel
          Layout.fillWidth: true
          height: 25
          //            visible: !app.hideAllControls
        }
        Item { height: 1 }
      }
    }
    MochiMenuPopup {
      id: menu
      // TODO: Make this work

      x: window.width - menu.width - 60
      y: window.height - panel.height - menu.height - 10
      //      z: 1

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
      // acceptProposedAction
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
