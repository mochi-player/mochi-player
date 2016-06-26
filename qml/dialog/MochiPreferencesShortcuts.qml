import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../widget"

Tab {
  property var conf
  title: qsTr("Shortcuts")

  ColumnLayout {
    anchors.fill: parent

    RowLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft

      MochiTextButton {
        Layout.alignment: Qt.AlignVCenter
        text: "-"
      }
      MochiTextButton {
        Layout.alignment: Qt.AlignVCenter
        text: "+"
      }
      MochiTextButton {
        Layout.alignment: Qt.AlignVCenter
        text: qsTr("Edit")
      }
      Item { width: MochiStyle.spacing.margin }
      MochiTextInput {
        id: search
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        placeholderText: "Search"
      }
      Item { width: MochiStyle.spacing.margin }
      MochiTextButton {
        Layout.alignment: Qt.AlignVCenter
        text: "Reset All"
      }
    }
    TableView {
      Layout.fillWidth: true
      Layout.fillHeight: true
      model: conf.input.keys
      TableViewColumn {
        role: "enabled"
        delegate: MochiCheckBox {
          checked: modelData
        }
      }
      TableViewColumn {
        role: "shortcut"
        title: qsTr("Shortcut")
        delegate: Text {
          text: modelData
        }
      }
      TableViewColumn {
        role: "description"
        title: qsTr("Description")
        delegate: Text {
          text: modelData
        }
      }
      TableViewColumn {
        role: "command"
        title: qsTr("Command")
        delegate: Text {
          text: modelData
        }
      }
    }
  }
}
