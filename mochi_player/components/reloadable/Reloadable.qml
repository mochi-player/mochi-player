import QtQuick 2.0
import FileSystemWatcher 1.0
import ReloadableEngine 1.0
import "../loadable"

Item {
  id: self

  property string source
  property string module: ""

  property alias item: loadable.item
  property alias status: loadable.status
  property alias props: loadable.props
  property alias exports: loadable.exports

  Loadable {
    id: loadable
    anchors.fill: parent
  }

  // Watch for changes to the reloadable source files
  FileSystemWatcher {
    paths: {
      var paths = [self.source]
      if (self.module !== "")
        paths.push(self.module)
      return paths
    }
    onFileChanged: function (path) {
      if (path === self.source) {
        reload(false)
      } else {
        reload(true)
      }
    }
  }

  // Reload the qml component and (potentially) the python component
  function reload(withModule) {
    console.log(`[re]loading ${self.source}`)
    loadable.source = ""
    ReloadableEngine.clearComponentCache()
    if (withModule && self.module !== "") {
      console.log(`[re]loading ${self.module}`)
      if (ReloadableEngine.reload(self.module) !== true) {
        return
      }
    }
    loadable.source = self.source
  }

  Component.onCompleted: reload(true)
}
