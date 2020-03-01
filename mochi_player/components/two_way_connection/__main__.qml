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
          left: inputTitle1; right: window
          props: [
            { leftProp: 'text', rightProp: 'title' },
          ]
        }
      }

      TextInput {
        id: inputTitle2

        Layout.fillWidth: true
        Layout.fillHeight: true

        TwoWayConnection {
          left: inputTitle2; right: window
          props: [
            { leftProp: 'text', rightProp: 'title' },
          ]
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
          left: inputWidth; right: window
          props: [
            {
              leftProp: 'text',
              leftHandler: function (leftVal) {
                return Number(leftVal)
              },
              rightProp: 'width',
              rightHandler: function (rightVal) {
                return String(rightVal)
              },
            }
          ]
        }
      }

      TextInput {
        id: inputHeight

        Layout.fillWidth: true
        Layout.fillHeight: true

        TwoWayConnection {
          left: inputHeight; right: window
          props: [
            {
              leftProp: 'text',
              leftHandler: function (leftVal) {
                return Number(leftVal)
              },
              rightProp: 'height',
              rightHandler: function (rightVal) {
                return String(rightVal)
              },
            }
          ]
        }
      }
    }
  }
}
