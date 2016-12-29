import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../style"
import "../widget"

ColumnLayout { // TODO
  anchors.fill: parent

  Item { width: Style.spacing.margin }
  Label {
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
    text: qsTr("Manage connected phones")
  }
  Item { width: Style.spacing.margin }
  TableView {
    Layout.fillWidth: true
    Layout.fillHeight: true
    model: remote.remotes
    TableViewColumn {
      role: "name"
      title: qsTr("Name")
      delegate: Text {
        text: modelData
      }
    }
    TableViewColumn {
      role: "ip"
      title: qsTr("IP")
      delegate: Text {
        text: modelData
      }
    }
  }
  RowLayout {
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
    Button {
      text: qsTr("Connect New")
      // todo
    }
    Item { width: Style.spacing.margin }
    Button {
      text: qsTr("Remove")
      // todo
    }
  }
  Label {
    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
    text: qsTr("Install the mochi-remote app on your phone to control mochi-player.<br>Android and iOS is supported.")
  }
  Item { width: Style.spacing.margin }
}
