#include "util.h"

#include <QUrl>
#include <QStringList>
#include <QTime>
#include <QDir>

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

QString serializeMedia(const QVariantMap &media, bool keepParent) {
  const int long_name = 100;
  if(!media["title"].toString().isEmpty())
    return media["title"].toString();
  QString p = QDir::fromNativeSeparators(media["filename"].toString());
  int i = p.lastIndexOf('/');
  if(i != -1) {
    int j = p.lastIndexOf('/', i-1);
    if(j != -1) {
      QString file = p.mid(i+1);
      if(file.length() > long_name) {
        file.truncate(long_name);
        i = p.lastIndexOf('.');
        file += "..";
        if(i != -1)
        {
          QString ext = p.mid(i);
          file.truncate(file.length()-ext.length());
          file += ext; // add the extension back
        }
      }
      if(keepParent) {
        if(i == j)
          return QDir::toNativeSeparators("/"+file);
        QString parent = p.mid(j+1, i-j-1);
        // todo: smarter trimming
        if(parent.length() > long_name) {
          parent.truncate(long_name);
          parent += "..";
        }
        return QDir::toNativeSeparators(parent+"/"+file);
      }
      else
        return file;
    }
  }
  return QDir::toNativeSeparators(media["filename"].toString());
}
