#include "config.h"

#include <QFile>
#include <QJsonDocument>
#include <QMetaProperty>

Config::Config(QObject *parent):
  QFileSystemWatcher(parent) {
  setObjectName("config");

  connect(this, &Config::fileChanged,
          this, &Config::load);
}

void Config::init() {
  defaults = getProperties(root, QVariantMap());
  if(!load())
    save();
  addPath(conf);
}

bool Config::load() {
  // Load configuration file as QJson

  if(!root)
    return false;

  QFile f(conf);
  if(f.open(QFile::ReadOnly | QIODevice::Text)) {
    setProperties(root, defaults,
                  QJsonDocument::fromJson(f.readAll()).toVariant().toMap());
    f.close();
  }
  else
    return false;

  emit loaded();
  return true;
}

bool Config::save() {
  // Save configuration file to QJson
  // (temporarily stop watching file to prevent reload)

  if(!root)
    return false;

  if(!files().empty())
    removePath(conf);

  QFile f(conf);
  if(f.open(QFile::WriteOnly | QFile::Truncate | QIODevice::Text)) {
    f.write(QJsonDocument::fromVariant(getProperties(root, defaults)).toJson());
    f.close();
  }
  else
    return false;

  addPath(conf);
  emit saved();
  return true;
}

void Config::setRoot(QObject *root) {
  emit rootChanged(this->root = root);
}

QVariantMap Config::getProperties(QObject *obj, const QVariantMap &defaults) {
  // Recurse through obj's properties and child QObjects' building a QVariantMap
  QVariantMap data;
  const QMetaObject *mobj = obj->metaObject();
  for(int i = 0; i < mobj->propertyCount(); i++) {
    QMetaProperty mprop = mobj->property(i);
    const char *name = mprop.name();
    if(mprop.isUser()) {
      QVariantMap::const_iterator p = defaults.constFind(name);
      if(p == defaults.end() || obj->property(name) != *p)
        data[name] = obj->property(name);
    }
  }
  for(QObjectList::const_iterator child = obj->children().constBegin();
      child != obj->children().constEnd(); child++) {
    if((*child)->objectName() != QString()) {
      QVariantMap props = getProperties(
            *child,
            defaults[(*child)->objectName()].toMap());
      if(!props.empty())
        data[(*child)->objectName()] = props;
    }
  }
  return data;
}

void Config::setProperties(QObject *obj, const QVariantMap &skel,
                           const QVariantMap &data) {
  // Recurse through obj's properties and child QObjects setting properties
  for(QVariantMap::const_iterator s = skel.constBegin();
      s != skel.constEnd(); s++) {
    QVariantMap::const_iterator d = data.constFind(s.key());
    if(s.value().canConvert<QVariantMap>()) {
      QObject *child = obj->findChild<QObject*>(s.key());
      if(child) {
        setProperties(child, s.value().toMap(),
                      (d == data.constEnd()) ?
                        QVariantMap() : d.value().toMap());
        continue;
      }
    }
    QVariant o = obj->property(s.key().toUtf8());
    if(o != s.value() && d == data.constEnd()) // different from skel
      obj->setProperty(s.key().toUtf8(), s.value());
    else if(d != data.constEnd() && o != d.value()) // different from data
      obj->setProperty(s.key().toUtf8(), d.value());
  }
}
