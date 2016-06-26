import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "."

Item {
  property var history: new Array()
  property var completions: new Array()
  property string filter
  property string type

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

    MochiTextArea {
      id: terminalOutput

      Layout.fillWidth: true
      Layout.fillHeight: true

      font.family: MochiStyle.font.code
      readOnly: true
    }

    MochiSeparator {
      Layout.fillWidth: true
    }

    MochiTextInput {
      id: terminalInput
      Layout.fillWidth: true
      placeholderText: ">"
      font.family: MochiStyle.font.code

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

      Rectangle {
        id: completionsBox

        anchors.bottom: parent.top
        anchors.left: parent.left
        anchors.bottomMargin: MochiStyle.spacing.margin
        height: completionsView.height
        width: completionsView.width
        color: MochiStyle.background.normal
        border.color: MochiStyle.background.accent
        border.width: 1
        z: 1
        visible: type != ""

        ListView {
          id: completionsView

          Keys.forwardTo: terminalInput
          height: Math.min(80, model.length * 15)
          width: 100

          model: completions.filter(function(t) {
            return t.indexOf(filter) == 0;
          })

          delegate: Rectangle {
            border.width: 1
            color: (index == completionsView.currentIndex) ? MochiStyle.background.accent : MochiStyle.background.normal
            width: completionsView.width
            height: 15
            Text {
              color: (index == completionsView.currentIndex) ? MochiStyle.text.accent : MochiStyle.text.normal
              text: modelData
            }
          }
        }
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
