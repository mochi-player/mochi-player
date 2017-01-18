import QtQuick 2.7
import Mochi 1.0 as Mochi

Mochi.Player {
  id: player

  property var videoTracks: player.tracks.filter(function(track) { return track.type == "video"; })
  property var audioTracks: player.tracks.filter(function(track) { return track.type == "audio"; })
  property var subtitleTracks: player.tracks.filter(function(track) { return track.type == "sub"; })
  property var debugLevels:   [
    "no",
    "fatal",
    "error",
    "warn",
    "info",
    "status",
    "v",
    "debug",
    "trace"]
  property var debugLevelsVerbose: [
    qsTr("No"),
    qsTr("Fatal"),
    qsTr("Error"),
    qsTr("Warn"),
    qsTr("Info"),
    qsTr("Status"),
    qsTr("Verbose"),
    qsTr("Debug"),
    qsTr("Trace")]
  property string vo: "opengl-cb"


  volume: 100
  speed: 1.0
  subs: true
  debug: "status"
  playlistAutoShow: true

  config: {
    "af": "scaletempo",
    "hwdec": "auto",
    "screenshot-directory": ".",
    "screenshot-format": "jpg",
    "screenshot-template": "screenshot%#04n",
    "ytdl": true,
    "ytdl-format": "bestvideo+bestaudio",
    "volume": player.volume,
    "speed": player.speed,
    "sub-visibility": player.subs
  }
}
