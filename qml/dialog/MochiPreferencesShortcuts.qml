import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../style"
import "../widget"

ColumnLayout {
  anchors.fill: parent

  RowLayout {
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft

    Button {
      Layout.alignment: Qt.AlignVCenter
      Image {
        anchors.centerIn: parent
        source: "qrc:/remove.svg"
        scale: 0.5
      }
    }
    Button {
      Layout.alignment: Qt.AlignVCenter
      Image {
        anchors.centerIn: parent
        source: "qrc:/add.svg"
      }
    }
    Button {
      Layout.alignment: Qt.AlignVCenter
      text: qsTr("Edit")
    }
    Item { width: Style.spacing.margin }
    TextField {
      id: search
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
      placeholderText: "Search"
    }
    Item { width: Style.spacing.margin }
    Button {
      Layout.alignment: Qt.AlignVCenter
      text: "Reset All"
    }
  }
  TableView {
    Layout.fillWidth: true
    Layout.fillHeight: true
    TableViewColumn {
      role: "enabled"
      delegate: CheckBox {
        checked: modelData
      }
    }
    TableViewColumn {
      role: "shortcut"
      title: qsTr("Shortcut")
    }
    TableViewColumn {
      role: "description"
      title: qsTr("Description")
    }
    TableViewColumn {
      role: "command"
      title: qsTr("Command")
    }
    model: {
      return Object.keys(inputs.key).map(function(k,i) {
        return {"section":"Keys","shortcut":k,"command":inputs.key[k]};
      })+Object.keys(inputs.mouse).map(function(k,i) {
          return {"section":"Mouse","shortcut":k, "command":inputs.mouse[k]};
      });
    }
    section.property: "section"
    section.criteria: ViewSection.FullString
  }
}
