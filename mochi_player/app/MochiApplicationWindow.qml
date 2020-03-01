import QtQuick 2.0
import QtQuick.Controls 2.5
import "../components/two_way_connection"

ApplicationWindow {
  id: self
  property QtObject state
  property QtObject action

  // Preserve State
  TwoWayConnection {
    left: self; right: self.state.window
    props: [
      { leftProp: 'title', rightProp: 'title' },
      { leftProp: 'width', rightProp: 'width' },
      { leftProp: 'height', rightProp: 'height' },
      { leftProp: 'visible', rightProp: 'visible' },
    ]
  }

  // Handle actions
  Connections {
    target: action.window
    onShow: self.show()
    onHide: self.hide()
  }
}
