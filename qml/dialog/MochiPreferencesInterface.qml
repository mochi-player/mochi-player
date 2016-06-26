import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../widget"

Tab {
  property var conf
  title: qsTr("Interface")

  ColumnLayout {
    anchors.fill: parent

    MochiGroupBox {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft
      text: qsTr("Window")

      ColumnLayout {
        RowLayout {
          ExclusiveGroup { id: fitDim }
          MochiRadioButton {
            exclusiveGroup: fitDim
            checked: conf.autoFit != -1
            text: qsTr("Fit window to video dimensions:")
          }
          MochiComboBox {
            id: fitPercent
            model: ["25%", "50%", "75%", "100%", "150%", "200%"]
            currentIndex: fitPercent.model.indexOf(conf.autoFit+"%")
            enabled: fitDim.checked
          }
        }
        MochiRadioButton {
          exclusiveGroup: fitDim
          text: qsTr("Remember previous window size")
        }
      }
    }
    MochiGroupBox {
      text: qsTr("History")
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft

      ColumnLayout {
        RowLayout {
          MochiCheckBox {
            id: recent
            text: qsTr("Remember recently opened files up to")
            checked: conf.numRecent != 0
            //                                checkedChanged: conf.numRecent = checked ? recentN.model[recentN.currentIndex] : 0
          }
          MochiSpinBox {
            id: recentN
            maximumValue: 1000
            value: conf.numRecent
            enabled: recent.checked
            //                                currentIndexChanged: conf.numRecent = model[currentIndex]
          }
        }
        MochiCheckBox {
          text: qsTr("Remember playback position")
          checked: conf.resume
          //                            checkedChanged: conf.resume = checked
        }
      }
    }
    RowLayout {
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft
      Layout.fillWidth: true

      MochiGroupBox {
        text: qsTr("Playlist")
        ExclusiveGroup { id: playlistAutoShow }
        ColumnLayout {
          MochiRadioButton {
            exclusiveGroup: playlistAutoShow
            text: qsTr("Intelligently auto show")
            checked: conf.playlist.autoShow
          }
          MochiRadioButton {
            exclusiveGroup: playlistAutoShow
            text: qsTr("Never auto show")
          }
        }
      }
//            MochiGroupBox {
//              text: qsTr("On Top")

//              ExclusiveGroup { id: onTop }
//              ColumnLayout {
//                MochiRadioButton {
//                  text: qsTr("Always")
//                  exclusiveGroup: onTop
//                  checked: conf.onTop == "always"
//                }
//                MochiRadioButton {
//                  text: qsTr("When Playing")
//                  exclusiveGroup: onTop
//                  checked: conf.onTop == "playing"
//                }
//                MochiRadioButton {
//                  text: qsTr("Never")
//                  exclusiveGroup: onTop
//                  checked: conf.onTop == "never"
//                }
//              }
//            }
      ColumnLayout {
        MochiGroupBox {
          text: qsTr("Tray Icon")
          MochiCheckBox {
            text: qsTr("Hide Popup")
            checked: conf.tray.visible
            onCheckedChanged: function(c) {
              conf.tray.visible = c;
            }
          }
        }
        MochiGroupBox {
          text: qsTr("Language")
          MochiComboBox {
            model: app.langs
            currentIndex: app.langs.indexOf(conf.lang)
            onCurrentIndexChanged: function(ind) {
              conf.lang = model[ind];
            }
          }
        }
      }
    }
  }
}
