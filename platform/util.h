#ifndef UTIL_H
#define UTIL_H

#include <QString>
#include <QVariant>
#include <QMimeData>

QVariant mimeDataToVariant(const QMimeData &mimeData);
QString serializeTime(int time, int totalTime = 0);

void showInFolder(QString path, QString file = QString());


#endif // UTIL_H
