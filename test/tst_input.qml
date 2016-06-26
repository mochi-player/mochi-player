import QtQuick 2.3
import QtTest 1.0
import Mochi 1.0 as Mochi

Mochi.Application {
  id: app

  Mochi.Input {
    id: input
    gestures: true
    width: 100
    height: 100
    key: {
      "A": "keySuccess()",
      "B*": "keySuccess()",
      "Ctrl+A": "keySuccess()",
      "Alt+A": "keySuccess()",
      "Ctrl+Shift+A": "keySuccess()",
    }
    mouse: {
      "LeftClick": "mouseSuccess()",
      "RightClick*": "mouseSuccess()",
      "MiddleDoubleClick": "mouseSuccess()",
      "WheelDown": "mouseSuccess()",
      "LeftVDrag": "mouseSuccess()",
      "RightHDrag": "mouseSuccess()",
      "MiddleDDrag": "mouseSuccess()"
    }
    Component.onCompleted: input.attach(this);
  }

  TestCase {
    id: mouseTest
    name: "InputMouseTest"
    when: windowShown
    property int successes

    function success() {
      mouseTest.successes++;
    }

    function mouseDragAndDrop(obj, x, y, dx, dy, button, modifiers, delay) {
      mouseDrag(obj, x, y, dx, dy, button, modifiers, delay);
      mouseRelease(obj, x+dx, y+dy, button, modifiers, delay);
    }

    function test_mouse() {
      var tests = 0;
      successes = 0;

      mouseClick(input, input.width/2, input.height/2, Qt.LeftButton, Qt.NoModifier, 100);
      compare(successes, ++tests, "Left Click");

      mouseRelease(input, input.width/2, input.height/2, Qt.RightButton, Qt.NoModifier, 100);
      expectFailContinue("", "Right Release Not Yet Implemented");
      compare(successes, ++tests, "Right Release");
      tests = successes;

      mouseDoubleClick(input, input.width/2, input.height/2, Qt.MiddleButton, Qt.NoModifier, 100);
      compare(successes, ++tests, "Middle Double Click");

      mouseWheel(input, input.width/2, input.height, 1, 0, Qt.NoButton, Qt.NoModifier, 100);
      compare(successes, ++tests, "Wheel Down");

      mouseDragAndDrop(input, input.width/2, input.height/2, 0, 2*input.height/3, Qt.LeftButton, Qt.NoModifier, 100);
      verify(successes >= ++tests, "Left Vertical Drag");
      tests = successes;

      mouseDragAndDrop(input, input.width/2, input.height/2, 2*input.width/3, 0, Qt.RightButton, Qt.NoModifier, 100);
      verify(successes >= ++tests, "Right Horizontal Drag");
      tests = successes;

      mouseDragAndDrop(input, input.width/2, input.height/2, 2*input.width/3, 2*input.height/3, Qt.MiddleButton, Qt.NoModifier, 100);
      expectFailContinue("", "Diagonal Drag Not Yet Implemented");
      verify(successes >= ++tests, "Middle Diagonal Drag");
      tests = successes;
    }
  }

  TestCase {
    id: keyTest
    name: "InputKeyTest"
    when: windowShown
    property int successes

    function success() {
      keyTest.successes++;
    }
    function test_key() {
      var tests = 0;
      successes = 0;

      keyClick('a', Qt.NoModifier, 100);
      compare(successes, ++tests, "Single Key");

      keyRelease('b', Qt.NoModifier, 100);
      compare(successes, ++tests, "Single Key Release");

      keyClick('A', Qt.ControlModifier, 100);
      compare(successes, ++tests, "Ctrl + Single Key");

      keyClick('A', Qt.AltModifier, 100);
      compare(successes, ++tests, "Alt  + Single Key");

      keyClick('A', Qt.ControlModifier | Qt.ShiftModifier, 100);
      compare(successes, ++tests, "Ctrl + Shift + Single Key");
    }
  }

  Component.onCompleted: {
    app.attach(this);
    app.addFunction("mouseSuccess", mouseTest.success);
    app.addFunction("keySuccess", keyTest.success);
  }
}
