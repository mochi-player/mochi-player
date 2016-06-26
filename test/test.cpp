#include <QtQuickTest/quicktest.h>

#include "tst_config.h"
#include "tst_player.h"
#include "tst_util.h"
#include "register.h"

QT_BEGIN_NAMESPACE
QTEST_ADD_GPU_BLACKLIST_SUPPORT_DEFS
QT_END_NAMESPACE

template <class T>
int Test(int argc, char *argv[]) {
  T t;
  return QTest::qExec(&t, argc, argv);
}

int TestQml(int argc, char *argv[]) {
  register_qml_types();
  return quick_test_main(argc, argv, "qmltest", QUICK_TEST_SOURCE_DIR);;
}

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setAttribute(Qt::AA_Use96Dpi, true);

    QTEST_DISABLE_KEYPAD_NAVIGATION
    QTEST_ADD_GPU_BLACKLIST_SUPPORT
    QTEST_SET_MAIN_SOURCE_PATH

    return Test<TestConfig>(argc, argv) ||
           Test<TestPlayer>(argc, argv) ||
           Test<TestUtil>(argc, argv) ||
           TestQml(argc, argv);
}
