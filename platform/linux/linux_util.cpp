#include "util.h"

#include <QDesktopServices>
#include <QUrl>

void showInFolder(QString path, QString) {
  QDesktopServices::openUrl(QUrl(QString("file:///%0").arg(path)));
}
