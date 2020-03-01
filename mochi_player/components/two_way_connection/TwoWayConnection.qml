import QtQuick 2.0

QtObject {
  id: self

  property var left
  property var right
  property var props
  property bool enabled: true

  onLeftChanged: self._reconnect()
  onRightChanged: self._reconnect()
  onPropsChanged: self._reconnect()
  onEnabledChanged: self._reconnect()

  property var _connections: undefined

  function _reconnect() {
    // Clear old connections
    if (self._connections !== undefined) {
      self._connections.destroy()
    }

    var left = self.left
    if (left === undefined) { return }
    var right = self.right
    if (right === undefined) { return }
    var props = self.props
    if (props === undefined) { return }
    var enabled = self.enabled
    if (enabled !== true) { return }

    console.log(JSON.stringify(self.props))

    var complete_props = []
    for (var prop of props) {
      var leftProp = prop.leftProp
      if (left[leftProp] === undefined) { throw new Error(`TwoWayBinding: missing leftProp (${leftProp})`) }

      var leftNotifySignal = prop.leftNotifySignal
      if (leftNotifySignal === undefined) { leftNotifySignal = `on${_capitalize(leftProp)}Changed` }

      var leftHandler = prop.leftHandler
      if (leftHandler === undefined) {
        leftHandler = function (leftVal) { return leftVal }
      }

      var rightProp = prop.rightProp
      if (right[rightProp] === undefined) { throw new Error(`TwoWayBinding: missing rightProp (${rightProp})`) }

      var rightNotifySignal = prop.rightNotifySignal
      if (rightNotifySignal === undefined) { rightNotifySignal = `on${_capitalize(rightProp)}Changed` }

      var rightHandler = prop.rightHandler
      if (rightHandler === undefined) {
        rightHandler = function (rightVal) { return rightVal }
      }

      complete_props.push({
        leftProp: leftProp,
        leftNotifySignal: leftNotifySignal,
        leftHandler: leftHandler,
        rightProp: rightProp,
        rightNotifySignal: rightNotifySignal,
        rightHandler: rightHandler,
      })
    }
    var code = `
      import QtQuick 2.7
      Item {
        id: self

        property QtObject target_left
        property QtObject target_right
        enabled: false

        ${complete_props.map(
          function (prop) {
            return [
              `signal notify_left_${prop.leftNotifySignal}`,
              `signal notify_right_${prop.rightNotifySignal}`,
            ].join('\n')
          }
        ).join('\n')}

        Connections {
          target: self.target_left
          enabled: self.enabled

          ${complete_props.map(
            function (prop) {
              return `${prop.leftNotifySignal}: self.notify_left_${prop.leftNotifySignal}()`
            }
          ).join('\n')}
        }

        Connections {
          target: self.target_right
          enabled: self.enabled

          ${complete_props.map(
            function (prop) {
              return `${prop.rightNotifySignal}: self.notify_right_${prop.rightNotifySignal}()`
            }
          ).join('\n')}
        }
      }
    `
    // console.debug(code)
    var connections = Qt.createQmlObject(code, self, 'two_way_connection_inline')
    connections.target_left = left
    connections.target_right = right
    for (var prop of complete_props) {
      connections[`notify_left_${prop.leftNotifySignal}`].connect(
        self._leftHandlerFactory(left, right, prop)
      )
      connections[`notify_right_${prop.rightNotifySignal}`].connect(
        self._rightHandlerFactory(left, right, prop)
      )
      left[prop.leftProp] = right[prop.rightProp]
    }
    connections.enabled = true
    self._connections = connections
  }

  function _capitalize(prop) {
    return prop.charAt(0).toUpperCase() + prop.slice(1)
  }


  function _leftHandlerFactory (left, right, prop) {
    return function () {
      var leftVal = prop.leftHandler(left[prop.leftProp])
      if (leftVal !== right[prop.rightProp]) {
        right[prop.rightProp] = leftVal
      }
    }
  }

  function _rightHandlerFactory (left, right, prop) {
    return function () {
      var rightVal = prop.rightHandler(right[prop.rightProp])
      if (rightVal !== left[prop.leftProp]) {
        left[prop.leftProp] = rightVal
      }
    }
  }
}
