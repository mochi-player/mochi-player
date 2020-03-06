from PyQt5.Qt import QTime

def serializeTime(time, totalTime):
  prefix = ''
  if time < 0:
    prefix = "-"
    time = -time
  if totalTime == 0:
    totalTime = time
  timeStr = QTime.fromMSecsSinceStartOfDay(time * 1000)
  if totalTime >= 3600:
    return prefix+timeStr.toString("h:mm:ss")
  elif totalTime >= 60:
    return prefix+timeStr.toString("mm:ss")
  else:
    return prefix+timeStr.toString("0:ss")
