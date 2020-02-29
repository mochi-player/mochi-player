import QtQuick.Controls 2.5

Action {
  property string _typeof: 'Action'

  // tags for this action determines where it will be visible on the UI
  //  e.g. a tag of `file` will appear in the file menu group.
  property var tags: []

  property string action
  onTriggered: {
    if (action) eval(action)
  }
}
