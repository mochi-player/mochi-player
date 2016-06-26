import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../widget"

Tab {
  property var conf
  title: qsTr("Subtitles")

  ColumnLayout {
    anchors.fill: parent

    RowLayout {
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft

      MochiText {
        text: qsTr("Codepage (sub-codepage):")
      }
      MochiTextInput {
        text: conf.codepage
      }
    }
  }
}
