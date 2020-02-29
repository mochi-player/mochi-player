import QtQuick 2.0
import QtQuick.Controls 2.5
import FileSystemWatcher 1.0

ApplicationWindow {
  title: 'filesystem watcher test'
  width: 500
  height: 500
  visible: true

  FileSystemWatcher {
    id: config
    paths: [Qt.resolvedUrl('.'), Qt.resolvedUrl('./__main__.qml')]
    onFileChanged: function (evt) {
      console.log(`fileChanged: ${evt}`)
    }
    onDirectoryChanged: function (evt) {
      console.log(`directoryChanged: ${evt}`)
    }
  }
}
