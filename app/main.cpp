#include <QtQml>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QUrl>

#include "platform.h"
#include "register.h"

int main(int argc, char *argv[]) {
  // Consistency for high resolution displays
  QApp::setAttribute(Qt::AA_EnableHighDpiScaling);

  // Create qt app
  QApp app(argc, argv);
  app.setObjectName("qt");

  // Register custom QML types
  register_qml_types();

  // Create and load qml engine
  QQmlApplicationEngine engine;
  engine.load(QUrl("qrc:/component/MochiApplication.qml"));

  return app.exec();
}
