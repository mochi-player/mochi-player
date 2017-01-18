#include "player.h"

#include <QString>
#include <QStringList>
#include <QMetaObject>
#include <QMetaMethod>
#include <QFileInfo>

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
  QString file;
  if(arg.canConvert<QString>())
    file = arg.toString();
  else if(arg.canConvert<QUrl>())
    file = arg.toUrl().toString();
  else if(arg.canConvert<QStringList>()) {
    QStringList args = arg.toStringList();
    if(!args.empty()) {
      file = args.front();
      args.pop_front();
      if(!args.empty()) {
        command_async(QStringList{"loadfile", file});
        for(auto &f : args)
          command_async(QStringList{"loadfile", f, "append"});
        setProperty("pause", false);
        return;
      }
    }
  } else if(arg.canConvert< QList<QUrl> >()) {
    QList<QUrl> args = arg.value< QList<QUrl> >();
    if(!args.empty()) {
      file = args.front().toString();
      args.pop_front();
      if(!args.empty()) {
        command_async(QStringList{"loadfile", file});
        for(auto &f : args)
          command_async(QStringList{"loadfile", f.toString(), "append"});
        setProperty("pause", false);
        return;
      }
    }
  }
  if(!file.isEmpty()) {
    if(playlistAutoShow) {
      QFileInfo f(file);
      if(f.isDir())
        command_async(QStringList{"loadfile", f.filePath()});
      else
        command_async(QStringList{"loadfile", f.path()});
    }
    else
      command_async(QStringList{"loadfile", file});
    setProperty("pause", false);
  }
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

void Player::screenshot() {
  command_async(QVariantList{"screenshot", subs ? "subtitles" : "video"});
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
