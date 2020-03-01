# Reloadable

Run demo and modify either `pymain.py` / `qmlmain.qml` source code to see instant qml hot reloading.

## Discussion

Ever since I started using React and noticed how similar it is to QML I wondered if there was a way to bring React's lovely hot-reloading mechanisms to QML; and it looks like the answer is yes. A [blog post](https://qml.guide/live-reloading-hot-reloading-qml/) offered the gist of how to do it, I just made it more convenient in the following ways:

- We're using *python*: Reloadables should be able to reload **python modules also**--with this they can
- Loader's work but they are kind of annoying--by default they make it difficult to pass properties to the underlying loaded object, Loadable's fix that

With this, our application can be built on modular reloadables whether they by python-based Qt extensions or QML components, we can reload them all~! Generally I've found it useful to set up components like so:

PyQt Extension:

`myext.py`:
```python
# my reloadable extension code

qmlRegisterType(...)
```

`_myext.qml`:
```qml
import MyExt 1.0

MyExt {
  property QtObject props: QtObject {
    // props you wish to be exposed
  }
}
```

`myext.qml`:
```qml
import "../Reloadable"

Reloadable {
  source: Qt.resolvedUrl("_myext.qml")
  module: Qt.resolvedUrl("myext.py")
}
```

Usage in general code--you can almost pretend it's not a reloadable!

`main.qml`:
```qml
Item {
  ...
  MyExt {
    props: QtObject {
      // props you wish to access
    }
  }
  ...
}
```

The same thing for QML components--minus the `module` property on the `Reloadable`.


## Caveats

I wish this worked perfectly, but basically Python *really* likes to garbage collect, when Qt doesn't notice. So you need to be careful with your pointers, otherwise a reload can result in a segfault, mainly when dealing with python code reloading. But it works pretty solid for general QML component reloading.
