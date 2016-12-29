import QtQuick 2.3
import QtQuick.Controls 1.0
import QtTest 1.0
import Mochi 1.0 as Mochi

TestCase {
  id: test
  name: "TrayTest"
  when: windowShown

  Mochi.Tray {
    id: tray
    icon: ":/logo.ico"
    menu: Mochi.Menu {
      Mochi.MenuItem {
        text: "Test1"
        onTriggered: function() {}
      }

      Mochi.MenuSeparator { }

      Mochi.Menu {
        title: "Test3"

        Mochi.MenuItem {
          text: "Test4"
          onTriggered: function() {}
        }
      }
    }
  }

  function test_tray() {
    ;
  }
}
