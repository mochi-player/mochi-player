import QtQuick 2.7
import QtQuick.Controls 1.4
import QtTest 1.0
import Mochi 1.0 as Mochi

Item {
  width: 100
  height: 100

  Mochi.Application {
    id: app
  }

  TestCase {
    id: test
    name: "ApplicationTest"
    objectName: "testobj"
    when: windowShown
    property bool success: false
    signal function_inject()

    function initTestCase() {
      app.attach(this);
    }

    SignalSpy {
      id: spy_message_handler
      target: app
      signalName: "message"
    }
    function test_message_handler() {
      app.installMessageHandler();
      console.log("test");
      spy_message_handler.wait(1000);
      verify(spy_message_handler.count >= 1);
    }

    SignalSpy {
      id: spy_function_inject
      target: test
      signalName: "function_inject"
    }
    function test_function_inject() {
      app.addFunction("testfunc", function() { test.function_inject() });
      testfunc();
      spy_function_inject.wait(1000);
      verify(spy_function_inject.count >= 1);
    }

    function test_object_inject() {
      app.addObject(test);
      testobj.success = true;
      verify(test.success);
    }

    function test_clipboard() {
      var clip = app.clipboard();
      app.clipboard(test.name);
      compare(app.clipboard(), test.name);
      app.clipboard(clip);
    }
  }
}
