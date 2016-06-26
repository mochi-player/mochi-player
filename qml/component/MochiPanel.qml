import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../widget"

Rectangle {
  property alias menuButton: menuButton

  color: MochiStyle.background.normal

  RowLayout {
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

    Item { width: 5 }

    MochiButton {
      source: "qrc:/open.svg"
      onClicked: function(event) {
        if(event.button == Qt.LeftButton)
          window.open();
        else if(event.button == Qt.RightButton)
          window.openLocation();
        else if(event.button == Qt.MiddleButton)
          window.jump();
      }
    }

    Item { width: 5 }

    MochiText {
      // TODO: Why is app not available here?
      text: app ? app.serializeTime(player.pos, player.duration) : ""
    }

    // TODO: (Figure out why the below code doesn't work)
    //    MochiText {
    //      text: app.remaining ? " / -" : " / "
    //      color: MochiStyle.text.soft
    //      visible: player.duration > 0
    //    }

    //    MochiTextButton {
    //      text: app.remaining ? app.serializeTime(100.0 - player.pos, player.duration) : app.serializeTime(100.0, player.duration)
    //      color: MochiStyle.text.soft
    //      font.weight: Font.Normal
    //      onClicked: app.remaining ^= true
    //    }
  }


  MochiButton {
    id: playButton
    anchors.centerIn: parent
    source: (player.path == "" || player.pause) ? "qrc:/play.svg" : "qrc:/pause.svg"
    onClicked: player.pause ^= true
    enabled: player.path != ""
  }

  RowLayout {
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: playButton.left

    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
    spacing: 20

    MochiButton {
      source: "qrc:/reverse.svg"
      onClicked: player.pos = 0.0
      enabled: player.path != ""
    }
    MochiButton {
      source: "qrc:/previous.svg"
      onClicked: playlist.index -= 1
      enabled: playlist.index > 0
    }
    Item { width: 5 }
  }

  RowLayout {
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: playButton.right

    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
    spacing: 20

    Item { width: 5 }
    MochiButton {
      source: "qrc:/next.svg"
      onClicked: playlist.index += 1
      enabled: (playlist.length - playlist.index) < 1
    }
    MochiButton {
      source: player.mute ? "qrc:/volume_mute.svg" : "qrc:/volume_unmute.svg"
      onClicked: player.mute ^= true
    }
    MochiSlider {
      width: 100
      pos: player.volume / 100.0
      onUpdatePos: function(pos) { player.volume = pos * 100.0; }
    }
  }

  RowLayout {
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
    spacing: 20
    
    MochiButton {
      id: menuButton
      source: "qrc:/menu.svg"
      onClicked: menu.visible ^= true
    }
    MochiButton {
      source: "qrc:/playlist.svg"
      onClicked: playlist.visible ^= true
      enabled: playlist.length > 1
    }

    Item { width: 5 }
  }
}
