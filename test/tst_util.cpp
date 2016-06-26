#include "tst_util.h"
#include "util.h"

#include <QTest>

void TestUtil::mimeDataToVariant() {
  QMimeData md;
  md.setText("test");
  QCOMPARE(::mimeDataToVariant(md).toString(), QString("test"));
  QList<QUrl> ul;
  ul.append(QUrl("test1"));
  ul.append(QUrl("test2"));
  md.setUrls(ul);
  QStringList sl = ::mimeDataToVariant(md).toStringList();
  QStringList l = {"test1", "test2"};
  QCOMPARE(sl, l);
}

void TestUtil::serializeTime_data() {
  QTest::addColumn<int>("time");
  QTest::addColumn<int>("totalTime");
  QTest::addColumn<QString>("result");

  QTest::newRow("simple") << 0 << 0 << "0:00";
  QTest::newRow("negative") << -10 << 0 << "-0:10";
  QTest::newRow("min:sec") << 60*60-1 << 0 << "59:59";
  QTest::newRow("hour:min:sec") << 10 << 60*60*60 << "0:00:10";
  QTest::newRow("bighour:min:sec") << 60*60*10 << 60*60*60 << "10:00:00";
}

void TestUtil::serializeTime() {
  QFETCH(int, time);
  QFETCH(int, totalTime);
  QFETCH(QString, result);
  QCOMPARE(::serializeTime(time, totalTime), result);
}
