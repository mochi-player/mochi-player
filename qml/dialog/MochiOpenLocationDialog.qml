import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../widget"

MochiDialog {
  title: qsTr("Open Path")
  width: 500
  height: 45

  RowLayout {
    anchors.fill: parent
    MochiText {
      Layout.alignment: Qt.AlignVCenter
      text: qsTr("Path:")
    }
    MochiTextInput {
      id: url
      Layout.fillWidth: true
      Layout.fillHeight: true
    }
    MochiButton {
      Layout.alignment: Qt.AlignVCenter
      source: 'qrc:/paste.svg'
      onClicked: url.text = app.clipboard()
    }
    MochiTextButton {
      Layout.alignment: Qt.AlignVCenter
      text: qsTr("Open")
      onClicked: accept()
    }
  }
}
