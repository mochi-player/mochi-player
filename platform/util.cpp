#include "util.h"

#include <QUrl>
#include <QStringList>
#include <QTime>

QVariant mimeDataToVariant(const QMimeData &mimeData) {
  if(mimeData.hasUrls()) {
    QStringList urls;
    for(auto &url : mimeData.urls())
      urls.append(url.toString());
    return urls;
  }
  else if(mimeData.hasText())
    return mimeData.text();
  return QString();
}

QString serializeTime(int time, int totalTime) {
  QString prefix;
  if(time < 0) {
    prefix = "-";
    time = -time;
  }
  if(totalTime == 0) {
    totalTime = time;
  }
  QTime timeStr = QTime::fromMSecsSinceStartOfDay(time * 1000);
  if(totalTime >= 3600) // hours
    return prefix+timeStr.toString("h:mm:ss");
  else if(totalTime >= 60)   // minutes
    return prefix+timeStr.toString("mm:ss");
  else
    return prefix+timeStr.toString("0:ss");   // seconds
}
