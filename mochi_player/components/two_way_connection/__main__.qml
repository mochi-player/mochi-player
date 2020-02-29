import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.14

ApplicationWindow {
  id: window

  title: "two way connection test"
  width: 400
  height: 400
  visible: true

  ColumnLayout {
    anchors.fill: parent

    RowLayout {
      Layout.fillWidth: true
      height: 10

      TextInput {
        id: inputTitle1

        Layout.fillWidth: true
        Layout.fillHeight: true

        TwoWayConnection {
          left: inputTitle1
          leftProp: 'text'
          right: window
          rightProp: 'title'
        }
      }

      TextInput {
        id: inputTitle2

        Layout.fillWidth: true
        Layout.fillHeight: true

        TwoWayConnection {
          left: inputTitle2
          leftProp: 'text'
          right: window
          rightProp: 'title'
        }
      }
    }

    RowLayout {
      Layout.fillWidth: true
      height: 10

      TextInput {
        id: inputWidth

        Layout.fillWidth: true
        Layout.fillHeight: true

        TwoWayConnection {
          left: inputWidth
          leftProp: 'text'
          leftHandler: function (leftVal) {
            return Number(leftVal)
          }
          right: window
          rightProp: 'width'
          rightHandler: function (rightVal) {
            return String(rightVal)
          }
        }
      }

      TextInput {
        id: inputHeight

        Layout.fillWidth: true
        Layout.fillHeight: true

        TwoWayConnection {
          left: inputHeight
          leftProp: 'text'
          leftHandler: function (leftVal) {
            return Number(leftVal)
          }
          right: window
          rightProp: 'height'
          rightHandler: function (rightVal) {
            return String(rightVal)
          }
        }
      }
    }
  }
}
