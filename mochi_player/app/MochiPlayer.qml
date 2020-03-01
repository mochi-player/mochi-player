import QtQuick 2.7
import MpvPlayer 1.0
import "../components/two_way_connection"

Item {
  id: self

  property QtObject state
  property QtObject action

  // Actual Mpv engine
  MpvPlayer {
    id: mpv
    anchors.fill: parent
  }

  // Sync player state with application state
  TwoWayConnection {
    left: mpv; right: self.state.player
    props: [
      { leftProp: 'chapter', rightProp: 'chapter' },
      { leftProp: 'dheight', rightProp: 'dheight' },
      { leftProp: 'duration', rightProp: 'duration' },
      { leftProp: 'dwidth', rightProp: 'dwidth' },
      { leftProp: 'filename', rightProp: 'filename' },
      { leftProp: 'mediaTitle', rightProp: 'mediaTitle' },
      { leftProp: 'mute', rightProp: 'mute' },
      { leftProp: 'path', rightProp: 'path' },
      { leftProp: 'pause', rightProp: 'pause' },
      { leftProp: 'seeking', rightProp: 'seeking' },
      { leftProp: 'speed', rightProp: 'speed' },
      { leftProp: 'timePos', rightProp: 'timePos' },
      { leftProp: 'volume', rightProp: 'volume' },
    ]
  }

  // Handle player actions
  Connections {
    target: self.action.player
    onLoad: function (paths) {
      if (typeof paths === 'object' && Array.isArray(paths)) {
        mpv.command(['loadfile', path[0].toString(), 'append-play'])
        for (const path of paths.slice(1)) {
          mpv.command(['loadfile', path.toString(), 'append'])
        }
      } else {
        mpv.command(['loadfile', paths.toString(), 'append-play'])
      }
    }
  }

  // we'll only pay attention to these actions when loaded
  Connections {
    target: self.action.player
    enabled: mpv.path !== ""
    onPlayPause: {
      mpv.pause = !mpv.pause
    }
    onSeekAbsolute: function (timePos) {
      if (!mpv.seeking) {
        var dt = timePos - mpv.timePos
        if (dt > 0) {
          mpv.command(['seek', `+${dt}`])
        } else {
          mpv.command(['seek', `${dt}`])
        }
      }
    }
    onSeekRelative: function (dt) {
      if (dt > 0) {
        mpv.command(['seek', `+${dt}`])
      } else {
        mpv.command(['seek', `${dt}`])
      }
    }
    onAdjustVolume: function (dv) {
      mpv.volume = Math.min(Math.max(mpv.volume + dv, 0), 100)
    }
  }
}
