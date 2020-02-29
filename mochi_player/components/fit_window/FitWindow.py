from PyQt5.QtCore import Qt, QRect,QPoint
from PyQt5.QtCore import QObject, pyqtSlot
from PyQt5.QtQml import qmlRegisterSingletonType

def adjust_to_aspect(geometry, desired_aspect):
  aspect = float(geometry.width()) / geometry.height()

  # If setting the width from the aspect ratio would result in a larger video,
  #  set instead the height. Otherwise set the width.
  if float(geometry.height()) * desired_aspect > geometry.width():
    # adjust width to reestablish aspect ratio
    new_geometry = QRect(
      0, 0,
      geometry.width(),
      round(float(geometry.width()) / desired_aspect)
    )
  else:
    # adjust height to reestablish aspect ratio
    new_geometry = QRect(
      0, 0,
      round(float(geometry.height()) * desired_aspect),
      geometry.height()
    )

  return new_geometry

def fit(
  video_geometry=QRect(), # the actual dimensions of the video
  display_geometry=QRect(), # the dimensions of the video being shown
  window_geometry=QRect(), # the dimensions of the window
  screen_geometry=QRect(), # the dimensions of the screen
  percent=0,
):
  ''' Fit window to a specific percentage factor of the video. '''

  video_aspect = float(video_geometry.width()) / video_geometry.height()

  # determine new intended display size
  if percent == 0:
    # set geometry by adjusting current geometry to match the video aspect ratio
    new_display_geometry = adjust_to_aspect(
      display_geometry,
      video_aspect
    )
  else:
    # set geometry as a direct scale of the video
    new_display_geometry = QRect(
      0, 0,
      round(float(video_geometry.width()) * percent),
      round(float(video_geometry.height()) * percent)
    )
  
  # calculate adjusted display geometry
  adjusted_display_width = new_display_geometry.width() - display_geometry.width()
  adjusted_display_height = new_display_geometry.height() - display_geometry.height()

  # determine the maximum aspect-correct window size
  extra_width = window_geometry.width() - display_geometry.width()
  extra_height = window_geometry.height() - display_geometry.height()
  screen_aspect = float(screen_geometry.height()) / screen_geometry.width()

  # precompute the two possible width,height pairs
  #  (width based on min height or height based on min width)
  #  if we aren't getting truncated by the screen, these will be the same
  potential_window_height = min(
    window_geometry.height() + adjusted_display_height,
    screen_geometry.height()
  )
  potential_window_width = min(
    window_geometry.width() + adjusted_display_width,
    screen_geometry.width()
  )
  computed_window_width = float(potential_window_height - extra_height) * video_aspect + extra_width
  computed_window_height = float(potential_window_width - extra_width) / video_aspect + extra_height

  # use the computed pair which do not exceed the screen dimensions
  if round(computed_window_width) <= screen_geometry.width():
    # Construct aspect-correct desired geometry
    new_window_geometry = QRect(
      0, 0,
      computed_window_width,
      potential_window_height
    )
  else:
    # Construct aspect-correct desired geometry
    new_window_geometry = QRect(
      0, 0,
      potential_window_width,
      computed_window_height
    )

  # re-center window in screen
  new_window_geometry.moveCenter(QPoint(
    screen_geometry.center().x(),
    screen_geometry.center().y()
  ))

  return new_window_geometry

class FitWindow(QObject):
  @pyqtSlot('QJSValue', result='QRect')
  def fit(self, args):
    return fit(**args.toVariant())
