import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../widget"

Tab {
  property var conf: conf
  title: qsTr("Remote")

  ColumnLayout {
    anchors.fill: parent

    Item { width: MochiStyle.spacing.margin }
    MochiText {
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft
      text: qsTr("Manage connected phones")
    }
    Item { width: MochiStyle.spacing.margin }
    TableView {
      Layout.fillWidth: true
      Layout.fillHeight: true
      model: conf.remote.remotes
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
      MochiTextButton {
        text: qsTr("Connect New")
        // todo
      }
      Item { width: MochiStyle.spacing.margin }
      MochiTextButton {
        text: qsTr("Remove")
        // todo
      }
    }
    MochiText {
      Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
      text: qsTr("Install the mochi-remote app on your phone to control mochi-player.<br>Android and iOS is supported.")
    }
    Item { width: MochiStyle.spacing.margin }
  }
}
