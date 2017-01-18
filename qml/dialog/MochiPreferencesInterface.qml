import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../widget"

ColumnLayout {
  GroupBox {
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
    title: qsTr("Window")

    ButtonGroup {
      id: autoFit
    }
    ColumnLayout {
      RowLayout {
        RadioButton {
          ButtonGroup.group: autoFit
          text: qsTr("Fit window to video dimensions:")

          checked: app.autoFit != 0
          onCheckedChanged: app.autoFit = checked ? 100 : 0
          Connections {
            target: app
            onAutoFitChanged: checked = (app.autoFit != 0)
          }
        }
        ComboBox {
          id: fitDimCombo
          model: ["25%", "50%", "75%", "100%", "150%", "200%"]
          enabled: app.autoFit != 0

          currentIndex: model.indexOf(app.autoFit+"%")
          onCurrentIndexChanged: app.autoFit = model[currentIndex].splice(0,-1)
          Connections {
            target: app
            onAutoFitChanged: currentIndex = model.indexOf(app.autoFit+"%")
          }
        }
      }
      RadioButton {
        ButtonGroup.group: autoFit
        text: qsTr("Remember previous window size")

        checked: app.autoFit == 0
        Connections {
          target: app
          onAutoFitChanged: checked = (app.autoFit == 0)
        }
      }
    }
  }
  GroupBox {
    title: qsTr("History")
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft

    ColumnLayout {
      RowLayout {
        CheckBox {
          id: recent
          text: qsTr("Remember recently opened files up to")

          checked: app.numRecent != 0
          onCheckedChanged: if(!checked) app.numRecent = 0
          Connections {
            target: app
            onNumRecentChanged: checked = (app.numRecent != 0)
          }
        }
        MochiSpinBox {
          id: recentN
          maximumValue: 1000
          enabled: app.numRecent != 0

          value: app.numRecent
          onValueChanged: app.numRecent = value
          Connections {
            target: app
            onNumRecentChanged: value = app.numRecent
          }
        }
      }
      CheckBox {
        text: qsTr("Remember playback position")

        checked: app.resume
        onCheckedChanged: app.resume = checked
        Connections {
          target: app
          onResumeChanged: checked = app.resume
        }
      }
    }
  }
  RowLayout {
    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
    Layout.fillWidth: true

    GroupBox {
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft

      title: qsTr("Playlist")
      ButtonGroup { id: playlistAutoShow }
      ColumnLayout { // TODO
        RadioButton {
          text: qsTr("Intelligently auto show")
          checked: player.playlistAutoShow
          ButtonGroup.group: playlistAutoShow
        }
        RadioButton {
          text: qsTr("Never auto show")
          ButtonGroup.group: playlistAutoShow
        }
      }
    }
    ColumnLayout {
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft

      GroupBox {
        title: qsTr("Tray Icon")

        CheckBox { // TODO
          text: qsTr("Hide Popup")
        }
      }
      GroupBox {
        title: qsTr("Language")
        ComboBox {
          model: app.langs

          currentIndex: app.langs.indexOf(app.lang)
          onCurrentIndexChanged: app.lang = app.langs[currentIndex]
          Connections {
            target: app
            onLangChanged: currentIndex = app.langs.indexOf(app.lang)
          }
        }
      }
    }
  }
}
