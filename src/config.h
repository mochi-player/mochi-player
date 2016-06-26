#ifndef CONFIG_H
#define CONFIG_H

#include <QObject>
#include <QFileSystemWatcher>
#include <QString>
#include <QVariantMap>

#include "property.h"

class Config : public QFileSystemWatcher {
  Q_OBJECT
  Q_CLASSINFO("Version", "2.1.0")

  M_PROPERTY(QObject*, root, WRITE setRoot)
  M_PROPERTY(QString, conf,)

public:
  explicit Config(QObject *parent = 0);

public slots:
  void init();
  bool load();
  bool save();
  void setRoot(QObject *root);

private slots:
  QVariantMap getProperties(QObject *, const QVariantMap &defaults);
  void setProperties(QObject *, const QVariantMap &skel, const QVariantMap &d);

signals:
  void loaded();
  void saved();

private:
  QVariantMap defaults;
};

#endif // CONFIG_H
