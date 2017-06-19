import QtQuick 2.7
import QtQuick.Controls 1.4
import QtTest 1.0
import Mochi 1.0 as Mochi

TestCase {
  id: test
  name: "PlayerTest"
  property var testfiles: ["./test1.webm", "./test2.webm"]
  signal idle
  signal played
  signal stopped
  signal playlistLoaded
  signal pathChanged

  ApplicationWindow {
    id: win
    width: 100
    height: 100
    visible: true

    Mochi.Player {
      id: player
      anchors.fill: parent

      debug: "status"

      onPlayStateChanged: function(state) {
        if(state == Mochi.Player.Failed)
          test.warn("Test file couldn't be loaded");
        else if(state == Mochi.Player.Playing)
          test.played();
        else if(state == Mochi.Player.Stopped)
          test.stopped();
        else if(state == Mochi.Player.Idle)
          test.idle();
      }

      onPlaylistChanged: function(playlist) {
        if(playlist.length > 1)
          test.playlistLoaded();
      }

      onPathChanged: test.pathChanged();
    }
  }

  SignalSpy {
    id: spy_idle
    target: test
    signalName: "idle"
  }

  SignalSpy {
    id: spy_played
    target: test
    signalName: "played"
  }

  SignalSpy {
    id: spy_stopped
    target: test
    signalName: "stopped"
  }

  SignalSpy {
    id: spy_path
    target: test
    signalName: "pathChanged"
  }

  SignalSpy {
    id: spy_playlist_loaded
    target: test
    signalName: "playlistLoaded"
  }

  function initTestCase() {
    spy_idle.wait();
    verify(spy_idle.count, "Mpv Initialized");
    spy_idle.clear();
  }

  function cleanupTestCase() {
    player.stop();
    spy_idle.wait();
    verify(spy_idle.count, "Mpv Initialized");
    spy_idle.clear();
  }

  function test_00_single_file() {
    player.load(testfiles[1]);

    spy_played.wait();
    verify(spy_played.count, "Test file loaded");
    spy_played.clear();

    player.frameBackStep();
    tryCompare(player, "pause", true, 1000, "Test file paused after frameStep");
    player.pause = false;

    spy_stopped.wait();
    verify(spy_stopped.count, "Test file stopped");
    spy_stopped.clear();
  }

  function test_01_multi_file() {
    // TODO: testfiles doesn't make it to player.play; it has something to do
    //       with QVariantList handling
    player.load(testfiles);

    spy_playlist_loaded.wait();
    verify(spy_playlist_loaded.count, "Playlist loaded");
    spy_playlist_loaded.clear();

    player.playlistPos += 1;
    tryCompare(player, "path", testfiles[1], 1000, "Next in playlist played");
  }

  function test_02_directory() {
    player.load(".");

    spy_playlist_loaded.wait();
    verify(spy_playlist_loaded.count, "Directory playlist loaded");
    spy_playlist_loaded.clear();

    // TODO: this fails because the playlist loads a bunch of non-playable files
    spy_path.wait();
    spy_path.clear();
    while(player.playlistPos < player.playlist.length && player.path != testfiles[0]) {
      player.playlistPos += 1;
      spy_path.wait();
      spy_path.clear();
    }
    tryCompare(player, "path", testfiles[0], 1000, "File found in directory");
  }
}
