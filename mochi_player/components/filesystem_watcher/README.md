# FileSystemWatcher

Modify `__main__.qml` or the directory itself and watch the FileSystemWatcher events fire.

## Discussion

Using the QFileSystemWatcher Qt component we fix it to work in Qml with urls because they are easier in Qml, and with properties instead of mutable `addPaths`/`removePaths` methods.
