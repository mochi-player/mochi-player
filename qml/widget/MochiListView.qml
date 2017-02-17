import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../style"
import "../widget"

Item {
  property var list
  property var listPos
  property alias currentIndex: listView.currentIndex
  property alias count: listView.count
  property bool shuffle: false
  property int indWidth: Math.min(
      (search.height / i.sourceSize.height) * i.sourceSize.width,
          t.boundingRect.width+Style.spacing.margin)

  TextMetrics {
    id: t
    font.family: Style.font.normal
    font.pointSize: Style.font.size
    text: listView.count
  }

  Image {
    id: i
    source: 'qrc:/play.svg'
    visible: false
  }

  Rectangle {
    anchors.fill: parent
    color: Material.background

    ColumnLayout {
      anchors.fill: parent
      spacing: 1

      TextField {
        id: search
        Layout.fillWidth: true
        placeholderText: qsTr("Search")
      }

      ListView {
        id: listView
        Layout.fillWidth: true
        Layout.fillHeight: true
        z: -1

        model: list.filter(function(e, i) {
          return String(i+1).indexOf(search.text) != -1 ||
                   (e.title && e.title.indexOf(search.text) != -1) ||
                   (e.filename && e.filename.indexOf(search.text) != -1);
        })
        delegate: Rectangle {
          anchors.left: parent.left
          anchors.right: parent.right
          height: search.height
          color: (index == listView.currentIndex) ? Material.primary : Material.background
          RowLayout {
            Layout.fillWidth: true
            height: parent.height
            Item {
              Layout.fillHeight: true
              Layout.alignment: Qt.AlignVCenter
              width: indWidth

              Image {
                anchors.centerIn: parent
                width: parent.width
                source: (index == listPos) ? 'qrc:/play.svg' : ''
                visible: index == listPos
              }
              Label {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: (index != listPos) ? index+1 : ''
                visible: index != listPos
              }
            }
            Label {
              Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
              Layout.fillWidth: true
              text: app.serializeMedia(modelData)
              font.weight: modelData.playing ? Font.Bold : Font.Normal
            }
//            Label {
//              text: modelData.duration
//            }
          }

          MouseArea {
            anchors.fill: parent
            onClicked: listView.currentIndex = index
            onDoubleClicked: listPos = index
          }
        }
      }
    }
  }
}
