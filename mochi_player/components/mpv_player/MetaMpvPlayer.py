'''
Metaclass for injecting qt properties into MpvPlayer from mpv
'''
from PyQt5.QtCore import Qt, pyqtSignal, pyqtSlot, pyqtProperty

def _pythonify(prop):
  prop_split = prop.split('-')
  return ''.join([
    prop_split[0],
    *[part.capitalize()
      for part in prop_split[1:]]
  ])

def _get_private(prop):
  return '_%s' % (_pythonify(prop))

def _get_notify(prop):
  return '%sChanged' % (_pythonify(prop))

def _getter_factory(prop):
  private_prop = _get_private(prop)
  def getter(self):
    return getattr(self, private_prop)
  getter.__name__ = private_prop
  return getter

def _setter_factory(prop, typ):
  private_prop = _get_private(prop)
  prop_notify = _get_notify(prop)
  def setter(self, value):
    if value is not None:
      value = typ(value)
      if getattr(self, private_prop) != value:
        setattr(self, private_prop, value)
        self.mpv.set_property(prop, value, asynchronous=True)
        getattr(self, prop_notify).emit()
  return setter

def MetaMpvPlayer(name, bases, attrs):
  for prop_name, typ in attrs['mpv_properties'].items():
    prop_notify_name = _get_notify(prop_name)
    prop_notify = pyqtSignal(name=prop_notify_name)
    attrs[prop_notify_name] = prop_notify
    prop = pyqtProperty(
      typ,
      fget=_getter_factory(prop_name),
      fset=_setter_factory(prop_name, typ),
      notify=prop_notify,
    )
    attrs[_pythonify(prop_name)] = prop
  return type(name, bases, attrs)
