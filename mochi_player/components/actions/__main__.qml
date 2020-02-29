import QtQuick 2.0
import QtQuick.Controls 2.5

ApplicationWindow {
  id: appwin
  title: 'actions test'
  width: 500
  height: 500
  visible: true

  Actions {
    id: a

    shortcuts: [
      {
        objectName: 'a',
        text: 'a',
        shortcut: 'C',
        action: `console.log('a.shortcut')`,
      },
      {
        objectName: 'd',
        text: 'd',
        shortcut: 'D',
        action: `console.log('d.shortcut')`,
      },
    ]

    Actions {
      ActionComponent {
        objectName: 'b'
        text: 'b'
        shortcut: 'B'
        onTriggered: function() { console.log('b.default') }
      }
    }

    ActionComponent {
      objectName: 'a'
      text: 'a'
      shortcut: 'A'
      onTriggered: function() { console.log('a.default') }
    }
  }
}