import QtQuick 2.0
import QtQuick.Controls 2.5
import GestureArea 1.0

ApplicationWindow {
  title: 'gesture area test'
  width: 500
  height: 500
  visible: true

  Item {
    anchors.fill: parent
    GestureArea {
      id: input
      anchors.fill: parent

      onLeftClick: console.log('single')
      onLeftDoubleClick: console.log('double')
      onLeftVDrag: function (d) { console.log(`vdrag ${d}`) }

      onGesture: function (evt, arg) {
        console.log(`${evt} action triggered ${arg.length > 0 ? `(${arg})` : ''}`)
      }
    }
  }
}
