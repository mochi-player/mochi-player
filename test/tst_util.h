#ifndef TST_UTIL_H
#define TST_UTIL_H

#include <QObject>

class TestUtil : public QObject {
  Q_OBJECT
private slots:
  void mimeDataToVariant();
  void serializeTime_data();
  void serializeTime();
};

#endif // TST_UTIL_H
