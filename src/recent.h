#ifndef RECENT_H
#define RECENT_H

#include <QObject>
#include <QVariantList>

#include "property.h"

class Recent : public QObject {
  Q_OBJECT
  Q_CLASSINFO("Version", "2.1.0")

  M_PROPERTY(int, max, USER true)
  M_PROPERTY(QVariantList, recent, USER true)
  M_PROPERTY(bool, resume, USER true)

public:
  explicit Recent(QObject *parent = 0);

public slots:

signals:

private:
};

#endif // RECENT_H
