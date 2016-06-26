#ifndef UPDATE_H
#define UPDATE_H

#include <QObject>
#include <QString>
#include <QDateTime>

#include "property.h"

class Update : public QObject {
  Q_OBJECT
  Q_CLASSINFO("Version", "2.1.0")

  M_PROPERTY(QDateTime, lastCheck, USER true)
  M_PROPERTY(QString, checkInterval, USER true)

public:
  explicit Update(QObject *parent = 0);

public slots:
  void updateStreaming();

signals:

private:
};

#endif // UPDATE_H
