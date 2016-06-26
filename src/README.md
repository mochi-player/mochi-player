# /src

Extra functionality for QML necessary for the application.

`application`: Takes over the QML Javascript Engine instance and enables injecting new functions and objects. Utilizing it for scripting exposes the full application runtime.
```
Application {
  Item {
    id: obj
  }
  Component.onCompleted: {
    app.attach(this);   // initialize Application
    app.addObject(obj); // expose obj to script engine
  }
}
```

`config`: Inspects a root QObject via QMeta tools to automatically create a JSON-style configuration of properties marked with `USER true`.
```
Application {
  id: app
  Config {
    id: config
    root: app
  }
  CustomObject {
    setting1: "this" // default settings specified in QML, overwritten by Config
  }
  Component.onCompleted: {
    config.init(); // initialize config (saves settings of all child objects)
  }
}
```

`input`: Handles all user keyboard and mouse input evaluating the assigned Javascript code defined in the QVariantMaps.
```
Input {
  key: {
    "Ctrl+A": "selectAll()" // When Ctrl+A is pressed, selectAll() is evaluated
  },
  mouse: {
    "LeftClick": "click()"
  }
}
```
