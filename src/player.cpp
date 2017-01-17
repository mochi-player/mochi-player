#include "player.h"

#include <QString>
#include <QStringList>
#include <QMetaObject>
#include <QMetaMethod>

Player::Player(QQuickItem *parent):
  MpvObject(parent) {
  setObjectName("player");

  // Initialize M_PROPERTIES (see player.h)
  const QMetaObject *obj = metaObject();
  for(int i = 0; i < obj->methodCount(); i++) {
    const QMetaMethod meth = obj->method(i);
    if(QString(meth.name()).startsWith("m_init_"))
      meth.invoke(this, Qt::DirectConnection);
  }

  // Handle changes in QML
  connect(this, SIGNAL(debugChanged(QString)),
          this, SLOT(setEngineLogLevel(QString)));
  connect(this, SIGNAL(configChanged(QVariantMap)),
          this, SLOT(setEngineConfig(QVariantMap)));
}

void Player::load(const QVariant &arg) {
  if(arg.canConvert<QString>())
    command_async(QStringList{"loadfile", arg.toString()});
  else if(arg.canConvert<QUrl>())
    command_async(QStringList{"loadfile", arg.toUrl().toString()});
  else if(arg.canConvert<QStringList>()) {
    QStringList args = arg.toStringList();
    if(!args.empty()) {
      load(args.front());
      args.pop_front();
      for(auto &f : args)
        command_async(QStringList{"loadfile", f, "append"});
    }
  }
  else if(arg.canConvert< QList<QUrl> >()) {
    QList<QUrl> args = arg.value< QList<QUrl> >();
    if(!args.empty()) {
      load(args.front());
      args.pop_front();
      for(auto &f : args)
        command_async(QStringList{"loadfile", f.toString(), "append"});
    }
  }
  else
    return;
  setProperty("pause", false);
}

void Player::stop() {
  setProperty("pause", true);
  seek(0.0, true);
}

void Player::seek(double time, bool absolute) {
  QStringList args{"seek", QString::number(time)};
  if(absolute)
    args.append("absolute");
  command_async(args);
}

void Player::frameStep() {
  command_async("frame-step");
}

void Player::frameBackStep() {
  command_async("frame-back-step");
}

//double Player::aspect() {
//  int width = property("width").toInt(),
//      height = property("height").toInt(),
//      dwidth = property("dwidth").toInt(),
//      dheight = property("dheight").toInt();

//  if(width == 0 || height == 0) // no video = no aspect
//    return 0;
//  if(dwidth == 0 || dheight == 0) // no display = video aspect
//    return double(width)/height;
//  else // else, display aspect
//    return double(dwidth)/dheight;
//}
