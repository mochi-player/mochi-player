import logging
import os.path
from urllib.parse import urlparse, urljoin
from urllib.request import pathname2url

from PyQt5.QtCore import QFileSystemWatcher, pyqtSlot, pyqtProperty, pyqtSignal
from PyQt5.QtQuick import QQuickItem

def url_to_path(url):
  p = urlparse(url)
  return os.path.abspath(os.path.join(p.netloc, p.path))

def path_to_url(path):
  return urljoin('file:', pathname2url(path))

class FileSystemWatcher(QQuickItem):
  directoryChanged = pyqtSignal('QString')
  fileChanged = pyqtSignal('QString')

  def __init__(self, *args, **kwargs):
    super().__init__(*args, **kwargs)

    self._paths = []
    self._watcher = QFileSystemWatcher()
    self._watcher.directoryChanged.connect(self._onDirectoryChanged)
    self._watcher.fileChanged.connect(self._onFileChanged)

  @pyqtSlot('QString')
  def _onDirectoryChanged(self, path):
    self.directoryChanged.emit(path_to_url(path))
  
  @pyqtSlot('QString')
  def _onFileChanged(self, path):
    self.fileChanged.emit(path_to_url(path))

  @pyqtProperty('QStringList')
  def paths(self):
    return self._paths
  
  @paths.setter
  def paths(self, val):
    added = list(map(url_to_path, set(val) - set(self._paths)))
    if added:
      logging.debug('adding {}'.format(added))
      self._watcher.addPaths(added)

    removed = list(map(url_to_path, set(self._paths) - set(val)))
    if removed:
      logging.debug('removing {}'.format(removed))
      self._watcher.removePaths(removed)

    self._paths = val

  def componentComplete(self):
    logging.debug('paths: {}'.format(self._watcher.files()))
