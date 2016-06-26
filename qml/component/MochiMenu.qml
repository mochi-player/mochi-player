import QtQuick 2.7
import QtQuick.Controls 1.4
import "../widget"

MochiMenuBar {
  Menu {
    title: qsTr("&File")

    MochiMenuItem {
      text: qsTr("&New Player")
      action: "app.newPlayer()"
    }
    MenuSeparator {}
    MochiMenuItem {
      text: qsTr("&Open File...")
      action: "window.open()"
    }
    MochiMenuItem {
      text: qsTr("Open &Location...")
      action: "window.openUrl()"
    }
    MochiMenuItem {
      text: qsTr("&Open &Copied Link")
      action: "player.load(app.clipboard())"
    }
    MochiRecent {
      title: qsTr("&Recently Opened")
      enabled: recent.length > 1
    }
    MenuSeparator {}
    MochiMenuItem {
      text: qsTr("Show in &Folder")
      action: "app.showInFolder(player.path);"
      enabled: player.path != ""
    }
    MenuSeparator {}
    MochiMenuItem {
      text: qsTr("Pla&y Next File")
      action: "playlist.next()"
      enabled: (playlist.length - playlist.index) > 1
    }
    MochiMenuItem {
      text: qsTr("Play &Previous File")
      action: "playlist.prev()"
      enabled: playlist.index > 0
    }
    MenuSeparator {}
    MochiMenuItem {
      text: qsTr("E&xit")
      action: "app.quit()"
    }
  }
  Menu {
    title: qsTr("&View")

    MochiMenuItem {
      text: qsTr("&Full Screen")
      action: "window.fullscreen ^= true"
    }
    Menu {
      title: qsTr("&Take &Screenshot")
      enabled: player.path != ""
      // TODO
    }
    MenuSeparator {}
    Menu {
      title: qsTr("Fit &Window")
      enabled: player.path != ""
      MochiMenuItem {
        text: qsTr("To &Current Size")
        action: "window.fit()"
      }
      MochiMenuItem {
        text: qsTr("&50%")
        action: "window.fit(50)"
      }
      MochiMenuItem {
        text: qsTr("&75%")
        action: "window.fit(75)"
      }
      MochiMenuItem {
        text: qsTr("&100%")
        action: "window.fit(100)"
      }
      MochiMenuItem {
        text: qsTr("15&0%")
        action: "window.fit(150)"
      }
      MochiMenuItem {
        text: qsTr("&200%")
        action: "window.fit(200)"
      }
    }
    Menu{
      title: qsTr("Aspect &Ratio")
      enabled: player.path != ""

      MochiMenuItem {
        text: qsTr("&Auto Detect")
        action: "player.aspect = -1"
      }
      MochiMenuItem {
        text: qsTr("Force &4:3")
        action: "player.aspect = 1.3333"
      }
      MochiMenuItem {
        text: qsTr("Force 16:&9")
        action: "player.aspect = 1.7777"
      }
      MochiMenuItem {
        text: qsTr("Force &2.35:1")
        action: "player.aspect = 2.35"
      }
    }
    MenuSeparator {}
    MochiMenuItem {
      text: qsTr("Show S&ubtitles")
      action: "player.subs ^= true"
      enabled: player.path != ""
      checked: player.subs
      checkable: true
    }
    Menu {
      title: qsTr("Subtitle &Track")
      enabled: player.tracks.length > 1 // TODO: filter for subtitle tracks

      // TODO
    }
    Menu {
      title: qsTr("Font Si&ze")
      enabled: player.path != ""

      MochiMenuItem {
        text: qsTr("&Size +")
        action: "player.subScale += 0.1"
      }
      MochiMenuItem {
        text: qsTr("S&ize -")
        action: "player.subScale -= 0.1"
      }
      MochiMenuItem {
        text: qsTr("&Reset Size")
        action: "player.subScale = 1.0"
      }
    }
    MenuSeparator {}
    MochiMenuItem {
      text: qsTr("&Motion Interpolation")
      // TODO
    }
    MochiMenuItem {
      text: qsTr("&Deinterlace")
      // TODO
    }
    MenuSeparator {}
    MochiMenuItem {
      text: qsTr("Show Playback &Info")
      enabled: player.path != ""
      // TODO
    }
  }
  Menu {
    title: qsTr("&Playback")

    MochiMenuItem {
      text: player.pause ? qsTr("&Play") : qsTr("&Pause")
      action: "player.pause ^= true"
      enabled: player.path != ""
    }
    MochiMenuItem {
      text: qsTr("&Stop")
      action: "player.stop()"
      enabled: player.path != ""
    }
    MochiMenuItem {
      text: qsTr("&Restart")
      action: "player.pos = 0.0"
      enabled: player.path != ""
    }
    Menu {
      title: qsTr("Spee&d")

      MochiMenuItem {
        text: qsTr("&Increase by 0.1")
        action: "player.speed += 0.1"
      }
      MochiMenuItem {
        text: qsTr("&Decrease by 0.1")
        action: "player.speed -= 0.1"
      }
      MenuSeparator {}
      MochiMenuItem {
        text: qsTr("&Reset")
        action: "player.speed = 1.0"
      }
    }
    MenuSeparator {}
    MochiMenuItem {
      text: qsTr("Sh&uffle")
      enabled: playlist.length > 1
    }
    Menu {
      title: qsTr("R&epeat")
      enabled: playlist.length > 1

      // TODO
    }
    MochiMenuItem {
      text: qsTr("Stop after &Current")
      enabled: playlist.length > 1
    }
    MenuSeparator {}
    Menu{
      title: qsTr("Audio &Tracks")
      enabled: player.tracks.length > 1 // Filter by audio
      // TODO
    }
    Menu {
      title: qsTr("&Volume")

      MochiMenuItem {
        text: qsTr("&Increase by 5%")
        action: "player.volume = Math.min(100.0, player.volume + 5.0)"
        enabled: player.volume < 100.0
      }
      MochiMenuItem {
        text: qsTr("&Decrease by 5%")
        action: "player.volume = Math.max(0.0, player.volume - 5.0)"
        enabled: player.volume > 0.0
      }
      MochiMenuItem {
        text: qsTr("&Mute")
        action: "player.mute ^= true"
        checked: player.mute
      }
    }
  }

  Menu {
    title: qsTr("&Navigate")

    MochiMenuItem {
      text: qsTr("&Next Chapter")
      action: "player.chapter += 1"
      enabled: (player.chapters.length - player.chapter) > 1
    }
    MochiMenuItem {
      text: qsTr("&Previous Chapter")
      action: "player.chapter -= 1"
      enabled: player.chapter > 0
    }
    Menu {
      title: qsTr("&Chapters")
      enabled: player.chapters.length > 0
      // TODO
    }
    MenuSeparator {}
    MochiMenuItem {
      text: qsTr("&Frame Step")
      action: "player.frameStep()"
      enabled: player.path != ""
    }
    MochiMenuItem {
      text: qsTr("Frame &Back Step")
      action: "player.frameBackStep()"
      enabled: player.path != ""
    }
    MenuSeparator {}
    MochiMenuItem {
      text: qsTr("&Jump to Time...")
      action: "window.jump()"
      enabled: player.duration > 0
    }
  }

  Menu {
    title: qsTr("&Settings")

    MochiMenuItem {
      text: qsTr("&Show Playlist")
      action: "playlist.visible ^= true"
      enabled: playlist.length > 1
    }
    MochiMenuItem {
      text: qsTr("Hide &Album Art")
      enabled: playlist.length > 1
      // TODO
    }
    MenuSeparator {}
    MochiMenuItem {
      text: qsTr("&Dim Lights")
      action: "window.dim()"
    }
    MochiMenuItem {
      text: qsTr("&Hide All Controls")
      action: "window.hideAllControls ^= true"
    }
    MochiMenuItem {
      text: qsTr("Show &Command Line")
      action: "window.showTerminal ^= true"
      checkable: true
      checked: window.showTerminal
    }
    MochiMenuItem {
      text: qsTr("&Preferences...")
      action: "window.preferences()"
    }
  }

  Menu {
    title: qsTr("&Help")

    MochiMenuItem {
      text: qsTr("Online &Help")
      action: "window.onlineHelp()"
    }
    MochiMenuItem {
      text: qsTr("&Check for Updates")
      action: "window.updates()"
    }
    MochiMenuItem {
      text: qsTr("Update &Streaming Support")
      action: "update.updateStreaming()"
    }
    MenuSeparator {}
    MochiMenuItem {
      text: qsTr("About &Qt")
      action: "app.aboutQt()"
    }
    MochiMenuItem {
      text: qsTr("About &Mochi-Player")
      action: "window.about()"
    }
  }
}
