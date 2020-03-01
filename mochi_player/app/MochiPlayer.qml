import QtQuick 2.0
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

    width: 0
    height: 0
  }

  // Sync player state with application state
  TwoWayConnection {
    left: mpv; leftProp: 'chapter'
    right: state.player; rightProp: 'chapter'
  }
  TwoWayConnection {
    left: mpv; leftProp: 'duration'
    right: state.player; rightProp: 'duration'
  }
  TwoWayConnection {
    left: mpv; leftProp: 'filename'
    right: state.player; rightProp: 'filename'
  }
  TwoWayConnection {
    left: mpv; leftProp: 'mediaTitle'
    right: state.player; rightProp: 'mediaTitle'
  }
  TwoWayConnection {
    left: mpv; leftProp: 'mute'
    right: state.player; rightProp: 'mute'
  }
  TwoWayConnection {
    left: mpv; leftProp: 'path'
    right: state.player; rightProp: 'path'
  }
  TwoWayConnection {
    left: mpv; leftProp: 'pause'
    right: state.player; rightProp: 'pause'
  }
  TwoWayConnection {
    left: mpv; leftProp: 'speed'
    right: state.player; rightProp: 'speed'
  }
  TwoWayConnection {
    left: mpv; leftProp: 'timePos'
    right: state.player; rightProp: 'timePos'
  }
  TwoWayConnection {
    left: mpv; leftProp: 'volume'
    right: state.player; rightProp: 'volume'
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
    onPlayPause: {
      mpv.command(['cycle', 'pause'])
    }
  }
}
