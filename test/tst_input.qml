import QtQuick 2.7
import QtQuick.Controls 1.4
import QtTest 1.0
import Mochi 1.0 as Mochi

Mochi.Application {
  id: app

  Mochi.Input {
    id: inputs
    gestures: true
    width: 100
    height: 100
    key: self._to_case("key")
    mouse: self._to_case("mouse")

    Component.onCompleted: inputs.attach(this);
  }

  Component.onCompleted: {
    app.attach(this);
    app.addFunction("success", self.success);
  }

  TestCase {
    id: self
    when: windowShown
    property alias a: app
    property alias i: inputs
    signal success(string type)

    function mouseDragAndDrop(obj, x, y, dx, dy, button, modifiers, delay) {
      mouseDrag(obj, x, y, dx, dy, button, modifiers, delay);
      mouseRelease(obj, x+dx, y+dy, button, modifiers, delay);
    }

    function _to_case(type) {
      return self.init_data()
      .filter(function(element) {
        return element.type == type;
      })
      .reduce(function(map, element) {
        map[element.binding] = "success('"+element.tag+"')";
        return map;
      }, {});
    }

    SignalSpy {
      id: spy
      target: self
      signalName: "success"
    }

    function init_data() {
      return [
        {type: "key", binding: "A", func: "function(t) {
          t.keyClick('a', Qt.NoModifier, 100);
        }"},
        {type: "key", binding: "B*", func: "function(t) {
          t.keyRelease('b', Qt.NoModifier, 100);
        }"},
        {type: "key", binding: "Ctrl+A", func: "function(t) {
          t.keyClick('A', Qt.ControlModifier, 100);
        }"},
        {type: "key", binding: "Alt+A", func: "function(t) {
          t.keyClick('A', Qt.AltModifier, 100);
        }"},
        {type: "key", binding: "Ctrl+Shift+A", func: "function(t) {
          t.keyClick('A', Qt.ControlModifier | Qt.ShiftModifier, 100);
        }"},
        {type: "mouse", binding: "LeftClick", func: "function(t) {
          t.mouseClick(t.i, t.i.width/2, t.i.height/2, Qt.LeftButton, Qt.NoModifier, 100);
        }"},
        {type: "mouse", binding: "RightClick*", func: "function(t) {
          t.mouseRelease(t.i, t.i.width/2, t.i.height/2, Qt.RightButton, Qt.NoModifier, 100);
        }", expect_fail: "Mouse Release Not Implemented"},
        {type: "mouse", binding: "MiddleDoubleClick", func: "function(t) {
          t.mouseDoubleClick(t.i, t.i.width/2, t.i.height/2, Qt.MiddleButton, Qt.NoModifier, 100);
        }"},
        {type: "mouse", binding: "WheelDown", func: "function(t) {
          t.mouseWheel(t.i, t.i.width/2, t.i.height, 1, 0, Qt.NoButton, Qt.NoModifier, 100);
        }"},
        {type: "mouse", binding: "LeftVDrag", func: "function(t) {
          t.mouseDragAndDrop(t.i, t.i.width/2, t.i.height/2, 0, 2*t.i.height/3, Qt.LeftButton, Qt.NoModifier, 100);
        }"},
        {type: "mouse", binding: "RightHDrag", func: "function(t) {
          t.mouseDragAndDrop(t.i, t.i.width/2, t.i.height/2, 2*t.i.width/3, 0, Qt.RightButton, Qt.NoModifier, 100);
        }"},
        {type: "mouse", binding: "MiddleDDrag", func: "function(t) {
          t.mouseDragAndDrop(t.i, t.i.width/2, t.i.height/2, 2*t.i.width/3, 2*t.i.height/3, Qt.MiddleButton, Qt.NoModifier, 100);
        }", expect_fail: "Diagonal Gestures Not Implemented"}
      ].map(function(v) {
        v.tag = v.type+"::"+v.binding;
        return v;
      });
    }

    function test_case(data) {
      app.evaluate(data.func)(self);
      if(data.expect_fail)
        expectFailContinue("", data.expect_fail);
      spy.wait();
      if(data.expect_fail)
        expectFailContinue("", data.expect_fail);
      verify(spy.signalArguments
             .map(function(v) { return v[0]; })
             .indexOf(data.tag) != -1);
      spy.clear();
    }
  }
}
