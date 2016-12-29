import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../widget"

ColumnLayout {
  anchors.fill: parent

  RowLayout {
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft

    Label {
      text: qsTr("Codepage (sub-codepage):")
    }
    TextField {
      text: player.codepage
    }
  }
}
