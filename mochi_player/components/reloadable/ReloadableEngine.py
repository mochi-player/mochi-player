import logging
import importlib
import os.path
from urllib.parse import urlparse
from PyQt5.QtCore import pyqtSlot, pyqtProperty
from PyQt5.QtQml import QQmlApplicationEngine

def url_to_path(url):
  p = urlparse(url)
  return os.path.abspath(os.path.join(p.netloc, p.path))

def path_to_relative_mod_name(path, module_dir=''):
  return '.' + os.path.relpath(
    os.path.splitext(path)[0],
    module_dir
  ).replace('/', '.')

class ReloadableEngine(QQmlApplicationEngine):
  def __init__(self, *args, parent=None,
    module_dir=os.path.dirname(os.path.abspath(__file__)),
    module_package=__package__,
    **kwargs
  ):
    super().__init__(*args, **kwargs)
    self._components = {}
    self._module_dir = module_dir
    self._module_package = module_package

  @pyqtProperty(str)
  def module_dir(self):
    return self._module_dir
  @module_dir.setter
  def module_dir(self, val):
    self._module_dir = val

  @pyqtProperty(str)
  def module_package(self):
    return self._module_package
  @module_package.setter
  def module_package(self, val):
    self._module_package = val

  @pyqtSlot()
  def clearComponentCache(self):
    return super().clearComponentCache()

  @pyqtSlot(str, result=bool)
  def reload(self, mod_url):
    mod_path = url_to_path(mod_url)
    mod_name = path_to_relative_mod_name(mod_path, self._module_dir)
    logging.debug('reloading {}...'.format(mod_name))
    mod = self._components.get(mod_name)
    try:
      if mod is None:
        self._components[mod_name] = importlib.import_module(
            mod_name, self._module_package)
      else:
        self._components[mod_name] = importlib.reload(mod)
    except Exception as e:
      logging.error(e)
      return False
    return True
