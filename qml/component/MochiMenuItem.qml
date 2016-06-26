import QtQuick 2.7
import QtQuick.Controls 1.4

MenuItem {
  property string action

  onTriggered: app.evaluate(action)
  shortcut: input.reverseKey[action] || undefined
}
