import QtQuick 2.3
import QtQuick.Controls 1.4
import QtTest 1.0
import Mochi 1.0 as Mochi

Item {
  Mochi.Application {
    id: app
    Component.onCompleted: app.attach(this);
  }

  TestCase {
    id: test
    name: "ApplicationTest"
    objectName: "testobj"
    when: windowShown
    property bool success: false

    function test_application() {
      app.addFunction("testfunc", function() { test.success = true; })
      testfunc();
      verify(success, "inject function");
      success = false;

      app.addObject(test);
      testobj.success = true;
      verify(success, "inject object");
      success = false;
    }
  }
}
