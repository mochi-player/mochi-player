import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../widget"

Dialog {
  title: qsTr("Open Path")
  width: 500
  height: 60

  RowLayout {
    anchors.fill: parent
    Label {
      Layout.alignment: Qt.AlignVCenter
      text: qsTr("Path:")
    }
    TextField {
      id: url
      Layout.fillWidth: true
      Layout.fillHeight: true
    }
    ImageButton {
      Layout.alignment: Qt.AlignVCenter
      source: 'qrc:/paste.svg'
      onClicked: url.text = app.clipboard()
    }
    Button {
      Layout.alignment: Qt.AlignVCenter
      text: qsTr("Open")
      onClicked: accept()
    }
  }
}
