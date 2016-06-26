import QtQuick 2.7
import Mochi 1.0 as Mochi

Mochi.Input {
  id: input

  gestures: true

  mouse: {
    "LeftVDrag": "function(p) { player.volume(p * 100.0); }",
    "LeftHDrag": "function(p) { player.seek(p * player.length); }",
    "LeftDoubleClick": "window.fullscreen ^= true",
    "RightClick": "player.pause ^= true",
    "WheelDown": "player.volume = Math.max(0.0, player.volume - 5.0)",
    "WheelUp": "player.volume = Math.min(100.0, player.volume + 5.0)"
  }

  key: {
    "Alt+1": "window.fit()",
    "Alt+2": "window.fit(50)",
    "Alt+3": "window.fit(75)",
    "Alt+4": "window.fit(100)",
    "Alt+5": "window.fit(150)",
    "Alt+6": "window.fit(200)",
    "Alt+Return": "window.fullscreen ^= true",
    "Ctrl+-": "player.subScale -= 0.1",
    "Ctrl++": "player.subScale += 0.1",
    "Ctrl+D": "window.dim()",
    "Ctrl+Down": "player.volume = Math.max(0.0, player.volume - 5.0)",
    "Ctrl+E": "app.showInFolder(player.path)",
    "Ctrl+F": "playlist.show ^= true",
    "Ctrl+G": "window.output ^= true",
    "Ctrl+J": "window.jump()",
    "Ctrl+Left": "playlist.prev()",
    "Ctrl+M": "player.mute ^= true",
    "Ctrl+N": "app.newPlayer()",
    "Ctrl+O": "window.open()",
    "Ctrl+Q": "app.quit()",
    "Ctrl+R": "player.seek(0, true)",
    "Ctrl+Right": "playlist.next()",
    "Ctrl+S": "player.stop()",
    "Ctrl+Shift+Down": "player.speed -= 0.1",
    "Ctrl+Shift+R": "player.speed = 1.0",
    "Ctrl+Shift+T": "player.screenshot('window')",
    "Ctrl+Shift+Up": "player.speed += 0.1",
    "Ctrl+T": "player.screenshot('subtitles')",
    "Ctrl+U": "window.openUrl()",
    "Ctrl+Up": "player.volume = Math.min(100.0, player.volume + 5.0)",
    "Ctrl+V": "player.load(app.clipboard())",
    "Ctrl+W": "player.subs ^= true",
    "Del": "playlist.remove(playlist.selected)",
    "Down": "playlist.selection += 1",
    "Esc": "window.isFullScreen() ? window.fullscreen(False) : window.boss()",
    "F1": "window.onlineHelp()",
    "Left": "player.seek(-5.0)",
    "PgDown": "player.chapter += 1",
    "PgUp": "player.chapter -= 1",
    "Return": "player.play(playlist.selected)",
    "Right": "player.seek(5.0)",
    "Shift+Left": "player.frame_back_step()",
    "Shift+Right": "player.frame_step()",
    "Space": "player.pause ^= true",
    "Tab": "overlay.media_info ^= true",
    "Up": "playlist.selection -= 1",
    "S": "player.speed = 2.0",
    "S*": "player.speed = 1.0"
  }

  // Creates a reversed version of key for command -> shortcut lookups
  property var reverseKey: Object.keys(key).reduce(function(p, c) {
    p[key[c]] = c;
    return p;
  },{})

  Component.onCompleted: input.attach(this);
}
