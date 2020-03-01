import QtQuick 2.0
import QtQuick.Controls 2.5
import "../components/actions"
import "../components/two_way_connection"

Item {
  id: self

  property QtObject state
  property QtObject action

  Actions {
    id: input
    ActionComponent {
      objectName: 'play_pause'; text: 'Play Pause'
      shortcut: ' '; onTriggered: self.action.player.playPause()
    }
  }

  TwoWayConnection {
    left: self.input; right: self.state.input
    props: [
      { leftProp: 'shortcuts', rightProp: 'shortcuts' },
    ]
  }
}
