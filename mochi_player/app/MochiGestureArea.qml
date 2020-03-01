import QtQuick 2.0
import GestureArea 1.0

Item {
  id: self

  property QtObject state
  property QtObject action
    
  GestureArea {
    id: gestureArea

    anchors.fill: parent

    onWheelUp: {
      if (self.state.input.mouse.wheelUp !== undefined) {
        eval(self.state.input.mouse.wheelUp)
      }
    }
    onWheelDown: {
      if (self.state.input.mouse.wheelDown !== undefined) {
        eval(self.state.input.mouse.wheelDown)
      }
    }
    onLeftClick: {
      if (self.state.input.mouse.leftClick !== undefined) {
        eval(self.state.input.mouse.leftClick)
      }
    }
    onMiddleClick: {
      if (self.state.input.mouse.middleClick !== undefined) {
        eval(self.state.input.mouse.middleClick)
      }
    }
    onRightClick: {
      if (self.state.input.mouse.rightClick !== undefined) {
        eval(self.state.input.mouse.rightClick)
      }
    }
    onLeftDoubleClick: {
      if (self.state.input.mouse.leftDoubleClick !== undefined) {
        eval(self.state.input.mouse.leftDoubleClick)
      }
    }
    onMiddleDoubleClick: {
      if (self.state.input.mouse.middleDoubleClick !== undefined) {
        eval(self.state.input.mouse.middleDoubleClick)
      }
    }
    onRightDoubleClick: {
      if (self.state.input.mouse.rightDoubleClick !== undefined) {
        eval(self.state.input.mouse.rightDoubleClick)
      }
    }
    onLeftVDrag: function (val) {
      if (self.state.input.mouse.leftVDrag !== undefined) {
        var _, state = self.state, action = self.action
        eval(`_ = ${self.state.input.mouse.leftVDrag}`)
        _(val)
      }
    }
    onLeftHDrag: function (val) {
      if (self.state.input.mouse.leftHDrag !== undefined) {
        var _, state = self.state, action = self.action
        eval(`_ = ${self.state.input.mouse.leftHDrag}`)
        _(val)
      }
    }
    onMiddleVDrag: function (val) {
      if (self.state.input.mouse.middleVDrag !== undefined) {
        var _, state = self.state, action = self.action
        eval(`_ = ${self.state.input.mouse.middleVDrag}`)
        _(val)
      }
    }
    onMiddleHDrag: function (val) {
      if (self.state.input.mouse.middleHDrag !== undefined) {
        var _, state = self.state, action = self.action
        eval(`_ = ${self.state.input.mouse.middleHDrag}`)
        _(val)
      }
    }
    onRightVDrag: function (val) {
      if (self.state.input.mouse.rightVDrag !== undefined) {
        var _, state = self.state, action = self.action
        eval(`_ = ${self.state.input.mouse.rightVDrag}`)
        _(val)
      }
    }
    onRightHDrag: function (val) {
      if (self.state.input.mouse.rightHDrag !== undefined) {
        var _, state = self.state, action = self.action
        eval(`_ = ${self.state.input.mouse.rightHDrag}`)
        _(val)
      }
    }
  }
}
