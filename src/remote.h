#ifndef REMOTE_H
#define REMOTE_H

#include <QObject>

#include "property.h"

class Remote : public QObject {
  Q_OBJECT
  Q_CLASSINFO("Version", "2.1.0")

  M_PROPERTY(bool, listen, USER true)
  M_PROPERTY(int, port, USER true)

public:
  explicit Remote(QObject *parent = 0);

public slots:

signals:

private:
};

#endif // REMOTE_H
