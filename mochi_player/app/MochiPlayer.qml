import QtQuick 2.0
import MpvObject 1.0

Item {
  id: self

  property QtObject state
  property QtObject action

  MpvObject {
    id: mpv

    anchors.fill: parent

    width: 0
    height: 0
  }

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
}
