import QtQuick 2.0

Item {
  id: self

  property alias source: loader.source
  property alias status: loader.status
  property alias item: loader.item
  onItemChanged: {
    if (item !== null) {
      _rewirePropBindings()
      _rewireExportBindings()
    }
  }

  Loader {
    id: loader
    asynchronous: true
    visible: status == Loader.Ready
    anchors.fill: parent
  }

  property var _bindingComponent: Component {
    Binding {}
  }

  property QtObject props
  property var _propBindings: []
  onPropsChanged: {
    if (item !== null) _rewirePropBindings()
  }

  function _rewirePropBindings() {
    var sourceProps = _allProps(self.props)

    // remove old prop bindings
    while (self._propBindings.length > 0) {
      self._propBindings.pop().destroy()
    }

    // add new prop bindings
    for (var _prop of sourceProps) {
      console.debug(`wiring prop binding for ${_prop}...`)
      self._propBindings.push(
        self._bindingComponent.createObject(self, {
            target: self.item,
            property: _prop,
            value: Qt.binding(function() { return self.props[_prop] }),
          }
        )
      )
      self.item[_prop] = self.props[_prop]
    }
  }

  property QtObject exports
  property var _exportBindings: []
  onExportsChanged: {
    if (item !== null) _rewireExportBindings()
  }

  function _rewireExportBindings() {
    var sourceExports = _allProps(self.exports)

    // remove old export bindings
    while (self._exportBindings.length > 0) {
      self._exportBindings.pop().destroy()
    }

    // add new export bindings
    for (var _export of sourceExports) {
      console.debug(`wiring export binding for ${_export}...`)
      self._exportBindings.push(
        self._bindingComponent.createObject(self, {
            target: self.exports,
            property: _export,
            value: Qt.binding(function() {
              if (self.item !== null) {
                return self.item[_export]
              }
            }),
          }
        )
      )
      self.exports[_export] = self.item[_export]
    }
  }

  function _allProps(obj) {
    var props = []
    for (var prop in obj) {
      if (/^(_.*|objectName.*|.*Changed)$/.exec(prop)) {
        continue
      }
      props.push(prop)
    }
    return props
  }

  function _notifySignalFor(obj, prop) {
    return obj[`on${_capitalize(prop)}Changed`]
  }

  function _capitalize(prop) {
    return prop.charAt(0).toUpperCase() + prop.slice(1)
  }
}
