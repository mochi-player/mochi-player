import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../widget"

Label {
  function _kv(k, v) {
    return "%s: %s\n".arg(k).arg(v);
  }
  text: player.mediaInfo.map(_kv) +
        (player.vid != -1 ? "\n"+player.videoParams.map(_kv) : "") +
        (player.aid != -1 ? "\n"+player.audioParams.map(_kv) : "")
}
