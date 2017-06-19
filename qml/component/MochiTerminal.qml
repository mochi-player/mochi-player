import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../style"
import "../widget"

Item {
  property var history: new Array()
  property var completions: new Array()
  property alias terminalOutput: terminalOutput
  property string filter
  property string type // TODO: type here should really be an Enum

  property string lastText
  property string lastType

  function _process(newText, newType) {
    // only process if a change occured
    if(newText == lastText && newType == lastType)
      return;
    else {
      lastText = newText;
      lastType = newType;
    }

    if(newType == "completions") {
      var ent;
      if(newText) {
        ent = newText.split(' ').pop().split('.');
        filter = ent.pop();
      }
      else
        filter = "";
      try {
        completions = Object.getOwnPropertyNames(eval(ent.join('.')));
      }
      catch(e) {
        completions = Object.getOwnPropertyNames(app.global());
      }
      completionsView.currentIndex = 0;
    }
    else if(newType == "history" && history.length > 0) {
      filter = newText;
      completions = history;
      completionsView.currentIndex = completionsView.model.length-1;
    }
    else {
      filter = "";
      completions = new Array();
    }

    type = newType;
  }

  function _expand(text) {
    var all = text.split(' ');
    var ent = all.pop().split('.');
    ent.pop();
    ent.push(completionsView.model[completionsView.currentIndex]);
    all.push(ent.join('.'));
    return all.join(' ');
  }

  ColumnLayout {
    anchors.fill: parent

    Flickable {
      Layout.fillWidth: true
      Layout.fillHeight: true

      TextArea.flickable: TextArea {
        id: terminalOutput
        wrapMode: TextArea.Wrap
        font.family: Style.font.code
        readOnly: true
      }

      ScrollBar.vertical: ScrollBar {
        position: 1
      }
    }


    RowLayout {
      Layout.fillWidth: true

      TextField {
        id: terminalInput
        Layout.fillWidth: true
        placeholderText: ">"
        font.family: Style.font.code

        Keys.onReleased: {
          if(type)
            _process(text, type);
        }

        Keys.onUpPressed: {
          if(type)
            completionsView.currentIndex = Math.max(0, completionsView.currentIndex - 1);
          else
            _process(text, "history");
        }

        Keys.onDownPressed: {
          if(type)
            completionsView.currentIndex = Math.min(completions.length, completionsView.currentIndex + 1);
          else
            _process(text, "completions");
        }

        Keys.onTabPressed: {
          if(type) {
            text = _expand(text);
            type = "";
          }
          else
            _process(text, "completions");
        }

        Keys.onEscapePressed: {
          _process(text, "");
        }

        Keys.onReturnPressed: {
          terminalOutput.append("In:  "+text);
          var out = app.evaluate(text);
          if(out)
            terminalOutput.append("Out: "+out);
          history.push(text);
          _process(text = "", "");
        }

        Popup {
          id: completionsBox
          x: terminalOutput.x
          y: terminalOutput.y - completionsBox.height - 30
          z: 1
          width: completionsView.contentWidth
          height: completionsView.height
          visible: type != ""

          ListView {
            id: completionsView

            x: 0
            y: 0
            height: Math.min(120, model.length * 30)
            width: 200

            Keys.forwardTo: terminalInput
            model: completions.filter(function(t) {
              return t.indexOf(filter) == 0;
            })

            delegate: Label {
              text: modelData
              height: 30
              background: Rectangle {
                color: (index == completionsView.currentIndex) ? Material.accent : Material.background
                width: completionsView.width
              }
            }
          }
        }
      }
      ImageButton {
        source: "qrc:/cmd_clear.svg"
        onClicked: clear()
      }
      ImageButton {
        source: "qrc:/cmd_save.svg"
        onClicked: app.saveOutput(terminalOutput.text)
      }
      ImageButton {
        source: "qrc:/cmd_help.svg"
        onClicked: window.onlineHelp()
      }
    }
  }

  function clear() {
    terminalOutput.text = "";
  }

  Component.onCompleted: {
    app.addFunction("clear", clear);
  }
}
