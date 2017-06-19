import QtQuick 2.0

Item {
  id: binding
  property alias leftItem: left.target
  property alias rightItem: right.target
  property alias leftProp: left.property
  property alias rightProp: right.property
  property alias leftVal: right.value
  property alias rightVal: left.value

  // Note that this ordering prefers the right value on initialization
  Binding {
    id: right
    value: leftItem[leftProp]
    when: binding.enabled
  }
  Binding {
    id: left
    value: rightItem[rightProp]
    when: binding.enabled
  }
}
