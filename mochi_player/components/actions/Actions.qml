import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
  id: self

  property string _typeof: 'Actions'
  property var _actionComponent: Qt.createComponent('ActionComponent.qml')

  // override a shortcut by action name
  property var shortcuts

  property var actions

  Component.onCompleted: self._updateActions()
  onShortcutsChanged: self._updateActions()

  function _updateActions() {
    console.info('updateActions...')

    var _actions = {}

    // Gather all specified actions
    for (var i = 0; i < self.data.length; i++) {
      var a = self.data[i]
      console.log(a)
  
      if (self._isActions(a)) {
        console.log('isactions')
        _notifySignalFor(a, 'actions').connect(self._updateActions)

        for (var aa in a.actions) {
          if (typeof _actions[aa] !== 'undefined') {
            console.error(`duplicate action ${aa} from ${a.objectName}`)
          }
          console.debug(`adding action ${aa}...`)
          _actions[aa] = a.actions[aa]
        }
      } else if (_isAction(a)) {
        console.log('isaction')
        if (typeof _actions[a.objectName] !== 'undefined') {
          console.error(`duplicate action ${a.objectName}`)
        }
        console.debug(`adding action ${a.objectName}...`)
        _actions[a.objectName] = a
      } else {
        console.warn(`unknown child type ${a} ignored`)
      }
    }

    // Map all shortcuts to existing
    //  or new actions.

    for (var shortcut of self.shortcuts) {
      if (typeof _actions[shortcut.objectName] !== 'undefined') {
        console.debug(`overriding action ${shortcut.objectName}...`)
        Object.assign(_actions[shortcut.objectName], shortcut)
      } else {
        console.debug(`creating action ${shortcut.objectName}...`)
        _actions[shortcut.objectName] = self._actionComponent.createObject(self, shortcut)
      }
    }

    // TODO: Detect and warn about
    //       duplication

    self.actions = _actions
  }

  function _isAction(a) {
    return a._typeof === 'Action'
  }

  function _isActions(a) {
    return a._typeof === 'Actions'
  }

  function _notifySignalFor(obj, prop) {
    return obj[`on${_capitalize(prop)}Changed`]
  }

  function _capitalize(prop) {
    return prop.charAt(0).toUpperCase() + prop.slice(1)
  }
}
