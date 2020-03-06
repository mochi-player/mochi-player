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
      { leftProp: 'chapterList', rightProp: 'chapterList' },
      { leftProp: 'chapter', rightProp: 'chapter' },
      { leftProp: 'dheight', rightProp: 'dheight' },
      { leftProp: 'duration', rightProp: 'duration' },
      { leftProp: 'dwidth', rightProp: 'dwidth' },
      { leftProp: 'filename', rightProp: 'filename' },
      { leftProp: 'mediaTitle', rightProp: 'mediaTitle' },
      { leftProp: 'mute', rightProp: 'mute' },
      { leftProp: 'path', rightProp: 'path' },
      { leftProp: 'pause', rightProp: 'pause' },
      { leftProp: 'playlistPos', rightProp: 'playlistPos' },
      { leftProp: 'playlist', rightProp: 'playlist' },
      { leftProp: 'seeking', rightProp: 'seeking' },
      { leftProp: 'speed', rightProp: 'speed' },
      { leftProp: 'subScale', rightProp: 'subScale' },
      { leftProp: 'subVisibility', rightProp: 'subVisibility' },
      { leftProp: 'timePos', rightProp: 'timePos' },
      { leftProp: 'trackList', rightProp: 'trackList' },
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
      mpv.command(['cycle', 'pause'])
    }
    onPlayPrev: {
      mpv.command(['playlist-prev'])
    }
    onPlayNext: {
      mpv.command(['playlist-next'])
    }
    onToggleSubtitles: {
      mpv.command(['cycle', 'sub-visibility'])
    }
    onTakeScreenshot: {
      mpv.command(['screenshot'])
    }
    onFrameStep: {
      mpv.command(['frame-step'])
    }
    onFrameBackStep: {
      mpv.command(['frame-back-step'])
    }
    onToggleMute: {
      mpv.command(['cycle', 'mute'])
    }
    onSetSpeed: function (s) {
      mpv.command(['set', 'speed', s])
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
