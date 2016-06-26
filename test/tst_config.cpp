#include "tst_config.h"
#include "config.h"

#include <QTest>
#include <QSignalSpy>

void TestConfig::init() {
  test1 = new ConfigTest1();
  test2 = new ConfigTest2(test1);
  test2->setParent(test1);
  c = new Config();
  c->setRoot(test1);
  c->setProperty("conf", testfile);
  c->init();
}

void TestConfig::cleanup() {
  if(c) delete c;
  if(test2) delete test2;
  if(test1) delete test1;
}

void TestConfig::create() {
  // Create and write initial configuration
  test1->update();
  test2->update();
  QVERIFY(c->save());
}

void TestConfig::open() {
  // Re-open configuration and check
  QVERIFY(c->load());
  test1->check();
  test2->check();
}

void TestConfig::doubleWrite() {
  test12 = new ConfigTest1();
  test22 = new ConfigTest2(test12);
  test22->setParent(test12);
  c2 = new Config();
  c2->setRoot(test12);
  c2->setProperty("conf", testfile);
  c2->init();

  // Write new configuration (while the existing one is still open)
  QVERIFY(c2->load());
  test12->check();
  test22->check();
  test12->update2();
  test22->update2();

  // wait for c to load after recognizing file change
  QSignalSpy spy(this, SIGNAL(success()));
  connect(c, &Config::loaded,
          this, [=]() {
    // ensure c did its job at the end (this gets called multiple times)
    QVERIFY(test1->compare(*test12));
    QVERIFY(test2->compare(*test22));
    emit success();
  });

  QVERIFY(c2->save());

  // Wait for c to recognize c2's change and update
  if(!spy.wait()) {
    QWARN("QFileSystemWatcher didn't work properly, manually loading config.");
    QVERIFY(c->load());
    QVERIFY(test1->compare(*test12));
    QVERIFY(test2->compare(*test22));
  }
}

void TestConfig::runtimeRestoreDefault() {
  // TODO: A special case exists if the input is removed at runtime
  //  which should revert to the default. A test for this should be devised.
}

void TestConfig::cleanupTestCase() {
  if(c2) delete c2;
  if(test22) delete test22;
  if(test12) delete test12;

  // Remove test config file
  QFile f(testfile);
  f.remove();
}

ConfigTest1::ConfigTest1(QObject *parent)
  :QObject(parent) {
  setObjectName("configTest1");
  itest = 10;
  btest = true;
  stest = "test";
  ltest.append("test1");
  ltest.append("test2");
  dtest["test1"] = "test1";
  dtest["test2"] = "test2";
}

bool ConfigTest1::compare(const ConfigTest1 &t) {
  return itest == t.itest &&
      btest == t.btest &&
      stest == t.stest &&
      ltest == t.ltest &&
      dtest == t.dtest;
}

void ConfigTest1::update() {
  itest = 0;
  btest = false;
  stest = "";
  ltest.clear();
  dtest.clear();
}

void ConfigTest1::update2() {
  itest = 10;
  btest = true;
  stest = "test";
  ltest.append("test1");
  ltest.append("test2");
  dtest["test1"] = "test1";
  dtest["test2"] = "test2";
}

void ConfigTest1::check() {
  QCOMPARE(itest, 0);
  QCOMPARE(btest, false);
  QCOMPARE(stest, QString(""));
  QCOMPARE(ltest, QVariantList());
  QCOMPARE(dtest, QVariantMap());
}

ConfigTest2::ConfigTest2(QObject *parent)
  :QObject(parent) {
  setObjectName("configTest2");
  itest = 0;
  btest = false;
  stest = "";
  ltest.clear();
  dtest.clear();
}

void ConfigTest2::update() {
  itest = 10;
  btest = true;
  stest = "test";
  ltest.append("test1");
  ltest.append("test2");
  dtest["test1"] = "test1";
  dtest["test2"] = "test2";
}

void ConfigTest2::update2() {
  itest = 0;
  btest = false;
  stest = "";
  ltest.clear();
  dtest.clear();
}

bool ConfigTest2::compare(const ConfigTest2 &t) {
  return itest == t.itest &&
      btest == t.btest &&
      stest == t.stest &&
      ltest == t.ltest &&
      dtest == t.dtest;
}

void ConfigTest2::check() {
  QCOMPARE(itest, 10);
  QCOMPARE(stest, QString("test"));
  QVariantList l;
  l.append("test1");
  l.append("test2");
  QCOMPARE(ltest, l);
  QVariantMap d;
  d["test1"] = "test1";
  d["test2"] = "test2";
  QCOMPARE(dtest, d);
}
