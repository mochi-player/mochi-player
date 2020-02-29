import QtQuick 2.0
import QtQuick.Controls 2.5
import "../components/two_way_connection"

ApplicationWindow {
  id: self
  property QtObject state

  TwoWayConnection {
    left: self; leftProp: 'title'
    right: state.window; rightProp: 'title'
  }
  TwoWayConnection {
    left: self; leftProp: 'width'
    right: state.window; rightProp: 'width'
  }
  TwoWayConnection {
    left: self; leftProp: 'height'
    right: state.window; rightProp: 'height'
  }
  TwoWayConnection {
    left: self; leftProp: 'visible'
    right: state.window; rightProp: 'visible'
  }
}
