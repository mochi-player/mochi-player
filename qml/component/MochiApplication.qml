import QtQuick 2.7
import QtQuick.Controls 1.4
import Mochi 1.0 as Mochi

Mochi.Application {
  id: app

  property var langs: ["auto", "en"]
  version: "2.1.0"
  url: "http://mochi-player.github.io/"
  debug: true
  init: ""
  autoFit: 100
  onTop: "never"
  remaining: false
  lang: "auto"
  screenshotDialog: true
  showAll: true
  splitter: 200
  hidePopup: true
  hideAllControls: false
  audioFiletypes: [
    "*.mp3", "*.ogg", "*.wav", "*.wma", "*.m4a", "*.aac",
    "*.ac3", "*.ape", "*.flac", "*.ra", "*.mka"]
  videoFiletypes: [
    "*.avi", "*.divx", "*.mpg", "*.mpeg", "*.m1v", "*.m2v",
    "*.mpv", "*.dv", "*.3gp", "*.mov", "*.mp4", "*.m4v",
    "*.mqv", "*.dat", "*.vcd", "*.ogm", "*.ogv", "*.asf",
    "*.wmv", "*.vob", "*.mkv", "*.ram", "*.flv", "*.rm",
    "*.ts", "*.rmvb", "*.dvr-ms", "*.m2t", "*.m2ts",
    "*.rec", "*.f4v", "*.hdmov", "*.webm", "*.vp8", "*.letv",
    "*.hlv"]
  mediaFiletypes: audioFiletypes.concat(videoFiletypes)
  subtitleFileypes: [
    "*.sub", "*.srt", "*.ass", "*.ssa"]
  width: 640
  height: 480
  onMessage: function(msg) { window.terminal.terminalOutput.append(msg); }

  MochiWindow {
    id: window

    title: player.title || "Mochi-Player"
    visible: true

    width: app.width
    onWidthChanged: app.width = window.width
    Connections {
        target: app
        onWidthChanged: window.width = app.width
    }

    height: app.height
    onHeightChanged: app.height = window.height
    Connections {
        target: app
        onHeightChanged: window.height = app.height
    }
  }

  MochiTray {
    id: tray
    tooltip: window.title
    visible: true
  }

  MochiRemote {
    id: remote
  }

  MochiUpdate {
    id: update
  }

  MochiConfig {
    id: config
    root: app
  }

  function quit() {
    config.save();
    Qt.quit();
  }

  Component.onCompleted: {
    // Forward internal messages to terminal and console
    app.installMessageHandler();

    // Attach QML's JSEngine to Application
    app.attach(this);

    // Expose objects to JSEngine
    [window, window.player, window.input, window.recent,
     tray, remote, update, config, app].map(function(obj) {
       app.addObject(obj);
     });

    // Expose functions to JSEngine
    app.addFunction("quit", quit);

    // Because QML has no good way to set the icon
    app.setIcon(window, window.icon);

    // Load in user configuration or write one
    config.init();

    // Load file/playlist from command line
    var args = app.arguments().slice(1);
    // TODO: parse command line arguments
    player.load(args);

    // Call user init script
    evaluate(app.init);
  }
}
