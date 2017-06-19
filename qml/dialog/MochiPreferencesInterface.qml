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
          id: autoFitRadioButton
          ButtonGroup.group: autoFit
          text: qsTr("Fit window to video dimensions:")

          TwoWayBinding {
            leftItem: autoFitRadioButton
            rightItem: app
            leftProp: 'checked'
            rightProp: 'autoFit'
            leftVal: autoFitRadioButton.checked ? fitDimCombo.model[fitDimCombo.currentIndex].split(0, -1) : 0
            rightVal: app.autoFit != 0
          }
        }
        ComboBox {
          id: fitDimCombo
          model: ["25%", "50%", "75%", "100%", "150%", "200%"]
          enabled: app.autoFit != 0

          TwoWayBinding {
            leftItem: fitDimCombo
            rightItem: app
            leftProp: 'currentIndex'
            rightProp: 'autoFit'
            leftVal: fitDimCombo.model[fitDimCombo.currentIndex].splice(0, -1)
            rightVal: fitDimCombo.model.indexOf(app.autoFit+"%")
            enabled: fitDimCombo.enabled
          }
        }
      }
      RadioButton {
        id: rememberRadioButton
        ButtonGroup.group: autoFit
        text: qsTr("Remember previous window size")

        TwoWayBinding {
          left: rememberRadioButton
          right: app
          leftProp: 'checked'
          rightProp: 'autoFit'
          leftVal: rememberRadioButton.checked ? 0 : null
          rightVal: app.autoFit === 0
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
          id: recentCheckBox
          text: qsTr("Remember recently opened files up to")

          TwoWayBinding {
            leftItem: recentCheckBox
            rightItem: app
            leftProp: 'checked'
            rightProp: 'numRecent'
            leftVal: recentCheckBox.checked ? recentN.value : 0
            rightVal: app.numRecent != 0
          }
        }
        MochiSpinBox {
          id: recentN
          maximumValue: 1000
          enabled: app.numRecent != 0

          TwoWayBinding {
            leftItem: recentN
            rightItem: app
            leftProp: 'value'
            rightProp: 'numRecent'
          }
        }
      }
      CheckBox {
        id: rememberCheckBox
        text: qsTr("Remember playback position")

        TwoWayBinding {
          leftItem: rememberCheckBox
          rightItem: app
          leftProp: 'checked'
          rightProp: 'resume'
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
          id: languageComboBox
          model: app.langs

          TwoWayBinding {
            leftItem: languageComboBox
            rightItem: app
            leftProp: 'currentIndex'
            rightProp: 'lang'
            leftVal: languageComboBox.model[languageComboBox.currentIndex]
            rightVal: languageComboBox.model.indexOf(app.lang)
          }
        }
      }
    }
  }
}
