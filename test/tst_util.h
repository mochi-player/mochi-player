#ifndef TST_UTIL_H
#define TST_UTIL_H

#include <QObject>

class TestUtil : public QObject {
  Q_OBJECT
private slots:
  void mimeDataToVariant();
  void serializeTime_data();
  void serializeTime();
  void serializeMedia_data();
  void serializeMedia();
};

#endif // TST_UTIL_H
