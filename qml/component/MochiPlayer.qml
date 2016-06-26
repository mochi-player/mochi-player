import QtQuick 2.7
import Mochi 1.0 as Mochi

Mochi.Player {
  id: player

  volume: 100
  speed: 1.0
  subs: true
  debug: "status"

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
