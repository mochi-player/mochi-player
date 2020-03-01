'''
Expand usefulness of MpvObject by exposing mpv commands and managing mpv properties through qt properties with the help of MetaMpvPlayer.
'''

import mpv as pympv
from PyQt5.QtCore import Qt, pyqtSignal, pyqtSlot
from PyQt5.QtQuick import QQuickItem
from .MpvObject import MpvObject
from .MetaMpvPlayer import MetaMpvPlayer, _pythonify, _get_private, _get_notify


class MpvPlayer(MpvObject, metaclass=MetaMpvPlayer):
  # mpv --list-properties
  mpv_properties = {
    'mute': bool,
    'volume': int,
    'filename': str,
    'media-title': str,
    'path': str,
    'pause': bool,
    'speed': float,
    'chapter': int,
  }

  def __init__(self, *args, **kwargs):
    super().__init__(self, *args, **kwargs)
    for prop_name, typ in self.__class__.mpv_properties.items():
      setattr(self, '_%s' % (_pythonify(prop_name)), typ())
      self.mpv.observe_property(prop_name)
    self.requestEvent(
      pympv.Events.property_change,
      self.handlePropertyChange
    )

  @pyqtSlot('QStringList')
  def command(self, params):
    self.mpv.command(*params)

  def handlePropertyChange(self, data):
    prop = data.name
    value = data.data
    setattr(self, _get_private(prop), value)
    getattr(self, _get_notify(prop)).emit()
