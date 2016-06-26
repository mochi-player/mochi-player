#ifndef TST_CONFIG_H
#define TST_CONFIG_H

#include <QObject>
#include <QString>
#include <QVariantList>
#include <QVariantMap>

#include "property.h"

class Config;
class ConfigTest1;
class ConfigTest2;
class TestConfig : public QObject {
  Q_OBJECT
private slots:
  void init();
  void create();
  void open();
  void doubleWrite();
  void runtimeRestoreDefault();
  void cleanup();
  void cleanupTestCase();

private:
  const QString testfile = "test.ini";
  ConfigTest1 *test1 = nullptr,
              *test12 = nullptr;
  ConfigTest2 *test2 = nullptr,
              *test22 = nullptr;
  Config      *c = nullptr,
              *c2;

signals:
  void success();
};

class ConfigTest1 : public QObject {
  Q_OBJECT
  M_PROPERTY(int, itest, USER true)
  M_PROPERTY(bool, btest, USER true)
  M_PROPERTY(QString, stest, USER true)
  M_PROPERTY(QVariantList, ltest, USER true)
  M_PROPERTY(QVariantMap, dtest, USER true)

public:
  ConfigTest1(QObject *parent = 0);

public slots:
  void update();
  void update2();
  void check();
  bool compare(const ConfigTest1 &t);
};

class ConfigTest2 : public QObject {
  Q_OBJECT
  M_PROPERTY(int, itest, USER true)
  M_PROPERTY(bool, btest, USER true)
  M_PROPERTY(QString, stest, USER true)
  M_PROPERTY(QVariantList, ltest, USER true)
  M_PROPERTY(QVariantMap, dtest, USER true)

public:
  ConfigTest2(QObject *parent = 0);

public slots:
  void update();
  void update2();
  void check();
  bool compare(const ConfigTest2 &t);
};

#endif // TST_CONFIG_H
