import QtQuick 2.0
import QtQuick.Controls 2.5
import "../components/actions"

Item {
  id: self

  property QtObject state
  property QtObject action

  Actions {
    id: input

    shortcuts: Object.keys(self.state.input.keys).map(
      function (key) {
        var val = self.state.input.keys[key]
        return {
          objectName: key,
          text: val,
          shortcut: key,
          action: function () {
            var state = self.state, action = self.action
            eval(val)
          },
        }
      }
    )
  }
}
