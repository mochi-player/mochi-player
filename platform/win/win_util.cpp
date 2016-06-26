#include "util.h"

#include <QProcess>
#include <QStringList>

void showInFolder(QString path, QString file) {
  QProcess::startDetached("explorer.exe", QStringList{"/select,", path+file});
}
