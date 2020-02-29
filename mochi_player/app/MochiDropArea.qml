import QtQuick 2.0

DropArea {
  id: self

  property QtObject state
  property QtObject action

  onEntered: function(event) {
    if(event.hasUrls || event.hasText)
      event.accepted = true;
    else
      event.accepted = false;
  }
  onDropped: function(event) {
    if(event.hasUrls) {
      self.action.player.load(event.urls)
      event.accepted = true;
    }
    else if(event.hasText) {
      self.action.player.load(event.text)
      event.accepted = true;
    }
    else
      event.accepted = false;
  }
}
