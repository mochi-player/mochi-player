import QtQuick 2.0

Item {
  id: self
  property QtObject state
  property QtObject action

  MochiSeekbar {
    state: self.state
    action: self.action

    anchors.fill: parent 
  }
}
