import QtQuick 2.7
import QtQuick.Controls 1.4
import QtTest 1.0
import "../qml/widget"

TestCase {
  id: test
  name: "TwoWayBinding Test"

  Item {
    id: left
    property string test1
    property int test2
  }
  Item {
    id: right
    property string test1: "test"
    property int test2: 1
  }

  TwoWayBinding {
    leftItem: left
    rightItem: right
    leftProp: 'test1'
    rightProp: 'test1'
  }

  TwoWayBinding {
    leftItem: left
    rightItem: right
    leftProp: 'test2'
    rightProp: 'test2'
    leftVal: left.test2 + 1
    rightVal: right.test2 - 1
  }

  SignalSpy {
    id: leftSpy1
    target: left
    signalName: 'onTest1Changed'
  }

  SignalSpy {
    id: rightSpy1
    target: right
    signalName: 'onTest1Changed'
  }

  SignalSpy {
    id: leftSpy2
    target: left
    signalName: 'onTest2Changed'
  }

  SignalSpy {
    id: rightSpy2
    target: right
    signalName: 'onTest2Changed'
  }

  function test_00_two_way_binding() {
    compare(left.test1, right.test1, "Left/Right props match")
    leftSpy1.clear()
    rightSpy1.clear()

    left.test1 = "test2"
    verify(rightSpy1.count, "Right received update signal")
    compare(left.test1, right.test1, "Left/Right props match after setting left")
    leftSpy1.clear()
    rightSpy1.clear()

    right.test1 = "test3"
    verify(leftSpy1.count, "Left received update signal")
    compare(left.test1, right.test1, "Left/Right props match after setting right")
    leftSpy1.clear()
    rightSpy1.clear()
  }

  function test_00_two_way_inverse_binding() {
    compare(left.test2, right.test2 - 1, "Left/Right props correct")
    leftSpy2.clear()
    rightSpy2.clear()

    left.test2++
    verify(rightSpy2.count, "Right received update signal")
    compare(left.test2, right.test2 - 1, "Left/Right props correct after setting left")
    leftSpy2.clear()
    rightSpy2.clear()

    right.test2++
    verify(leftSpy2.count, "Left received update signal")
    compare(left.test2, right.test2 - 1, "Left/Right props correct after setting right")
    leftSpy2.clear()
    rightSpy2.clear()

    compare(left.test2, 2, "Left prop is the right value (2).")
  }
}
