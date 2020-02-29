import QtQuick 2.0

QtObject {
  id: self

  property var left
  property string leftProp
  property string leftNotifySignal
  property var leftHandler
  onLeftChanged: self._reconnect()

  property var right
  property string rightProp
  property string rightNotifySignal
  property var rightHandler
  onRightChanged: self._reconnect()

  property var _connections: []

  function _reconnect() {
    var left = self.left
    if (left === undefined) { return }
    var right = self.right
    if (right === undefined) { return }

    // Clear old connections
    while (self._connections.length > 0) {
      self._connections.pop().destroy()
    }

    var leftProp = self.leftProp
    if (left[leftProp] === undefined) { throw new Error(`TwoWayBinding: missing leftProp (${leftProp})`) }

    var leftNotifySignal = self.leftNotifySignal
    if (leftNotifySignal === "") { leftNotifySignal = `on${_capitalize(leftProp)}Changed` }
    // if (left[leftNotifySignal] === undefined) { throw new Error(`TwoWayBinding: missing leftNotifySignal (${leftNotifySignal})`) }

    var leftHandler = self.leftHandler
    if (leftHandler === undefined) {
      leftHandler = function (leftVal) { return leftVal }
    }

    var rightProp = self.rightProp
    if (right[rightProp] === undefined) { throw new Error(`TwoWayBinding: missing rightProp (${rightProp})`) }

    var rightNotifySignal = self.rightNotifySignal
    if (rightNotifySignal === "") { rightNotifySignal = `on${_capitalize(rightProp)}Changed` }
    // if (right[rightNotifySignal] === undefined) { throw new Error(`TwoWayBinding: missing rightNotifySignal (${rightNotifySignal})`) }

    var rightHandler = self.rightHandler
    if (rightHandler === undefined) {
      rightHandler = function (rightVal) { return rightVal }
    }

    // console.debug(`${left}.${leftNotifySignal} = { ${right}.${rightProp} = ${left}.${leftProp} }`)
    var leftConnection = Qt.createQmlObject(`
      import QtQuick 2.7
      Item {
        id: self
        property QtObject target
        property bool enabled: false
        signal notify

        Connections {
          id: connections
          target: self.target
          enabled: self.enabled
          ${leftNotifySignal}: self.notify()
        }
      }
    `, self, 'two_way_connection_inline')
    leftConnection.target = left
    leftConnection.notify.connect(
      function () {
        var leftVal = leftHandler(left[leftProp])
        if (leftVal !== right[rightProp]) {
          // console.debug('left changed, update right')
          right[rightProp] = leftVal
        }
      }
    )
    leftConnection.enabled = true
    self._connections.push(leftConnection)

    // console.debug(`${right}.${rightNotifySignal} = { ${left}.${leftProp} = ${right}.${rightProp} }`)
    var rightConnection = Qt.createQmlObject(`
      import QtQuick 2.7
      Item {
        id: self
        property QtObject target
        property bool enabled: false
        signal notify

        Connections {
          id: connections
          target: self.target
          enabled: self.enabled
          ${rightNotifySignal}: self.notify()
        }
      }
    `, self, 'two_way_connection_inline')
    rightConnection.target = right
    rightConnection.notify.connect(
      function () {
        var rightVal = rightHandler(right[rightProp])
        if (rightVal !== left[leftProp]) {
          // console.debug('right changed, update left')
          left[leftProp] = rightVal
        }
      }
    )
    rightConnection.enabled = true
    self._connections.push(rightConnection)

    left[leftProp] = right[rightProp]
  }

  function _capitalize(prop) {
    return prop.charAt(0).toUpperCase() + prop.slice(1)
  }
}
