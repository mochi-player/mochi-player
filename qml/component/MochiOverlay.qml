import QtQuick 2.7
import "../widget"

Text {
  function _kv(k, v) {
    return "%s: %s\n".arg(k).arg(v);
  }
  color: MochiStyle.text.overlay
  text: player.mediaInfo.map(_kv) +
        (player.vid != -1 ? "\n"+player.videoParams.map(_kv) : "") +
        (player.aid != -1 ? "\n"+player.audioParams.map(_kv) : "")
}
