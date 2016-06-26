#ifndef TEST_H
#define TEST_H

#include <QTest>

class Test : public QObject {
  Q_OBJECT
signals:
  void success();

private slots:
  void sanity();
  void utilMimeDataToVariant();
  void utilSerializeTime();
  void config();
  void player();
};

#endif
