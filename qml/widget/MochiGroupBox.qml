import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "."

GroupBox {
  id: obj
  property alias text: obj.title
}

//FocusScope {
//  id: obj
//  property alias text: t.text
//  default property alias data: content.data

//  implicitWidth: childrenRect.width
//  implicitHeight: childrenRect.height

//  ColumnLayout {
//    MochiText {
//      id: t
//      Layout.alignment: Qt.AlignTop
//    }
//    Item {
//      id: content
//      Layout.alignment: Qt.AlignTop
//      Layout.fillHeight: true
//    }
//  }
//}
