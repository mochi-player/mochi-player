# Loadable

This demo illustrates utilizing property signal binding through a loaded component (something not supported by the QtQuick `Loader`)

## Discussion

Unlike a `Loader`, a `Loadable` provides a means for accessing and modifying props of the loaded component that can ignore the fact that it's a reloader (i.e. use aliases, bind signals at initialization, etc..)

- `property QtObject props` should be specified at call-site and on the component to pass props from parent to child.
- `property QtObject exports` should be specified at call-site and on the component to pass exports from child to parent.

This helps us make Reloadables (which depend on Loaders) into seamless components.
