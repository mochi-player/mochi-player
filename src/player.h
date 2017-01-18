#ifndef PLAYER_H
#define PLAYER_H

#include <QObject>
#include <QString>
#include <QVariant>
#include <QVariantMap>
#include <QMetaObject>

#include "property.h"
#include "lib_player.h"

class Player : public PlayerEngine {
  Q_OBJECT
  Q_CLASSINFO("Version", "2.1.0")

  // Custom property macro:
  //  defines Q_PROPERTY, setProperty function, member definition,
  //  signal definition, engine property two-way binding
  #define M_PROPERTY_EX(type, name, engine_name) \
    M_PROPERTY(type, name, WRITE m_set_##name) \
    public: \
      Q_SLOT void m_set_##name(type value, bool fromEngine = false) { \
        emit name##Changed(name = value); \
        if(!fromEngine) \
          setEnginePropertyAsync(engine_name, value); \
      } \
    private: \
      Q_SLOT void m_init_##name() { \
        setEnginePropertyCallback(engine_name, [=](const QVariant &value) { \
          m_set_##name(value.value< type >(), true); \
        }); \
      }

  M_PROPERTY_EX(bool, mute, "ao-mute")
  M_PROPERTY_EX(bool, pause, "pause")
  M_PROPERTY_EX(bool, subs, "sub-visibility")
  M_PROPERTY_EX(double, duration, "duration")
  M_PROPERTY_EX(double, pos, "percent-pos")
  M_PROPERTY_EX(double, speed, "speed")
  M_PROPERTY_EX(double, volume, "ao-volume")
  M_PROPERTY_EX(double, aspect, "video-aspect")
  M_PROPERTY_EX(double, subScale, "sub-scale")
  M_PROPERTY_EX(int, aid, "aid")
  M_PROPERTY_EX(int, chapter, "chapter")
  M_PROPERTY_EX(int, playlistPos, "playlist-pos")
  M_PROPERTY_EX(int, sid, "sid")
  M_PROPERTY_EX(int, vid, "vid")
  M_PROPERTY_EX(int, vWidth, "width")
  M_PROPERTY_EX(int, vHeight, "height")
  M_PROPERTY_EX(QString, path, "path")
  M_PROPERTY_EX(QString, name, "filename/no-ext")
  M_PROPERTY_EX(QString, title, "media-title")
  M_PROPERTY_EX(QVariantList, chapters, "chapter-list")
  M_PROPERTY_EX(QVariantList, playlist, "playlist")
  M_PROPERTY_EX(QVariantList, tracks, "track-list")
  M_PROPERTY_EX(QVariantMap, aparams, "audio-params")
  M_PROPERTY_EX(QVariantMap, vparams, "video-params")

  M_PROPERTY(bool, playlistAutoShow, USER true)
  M_PROPERTY(QString, debug, USER true)
  M_PROPERTY(QVariantMap, config, USER true)

public:
  explicit Player(QQuickItem * parent = 0);

public slots:
  void load(const QVariant &arg);
  void stop();
  void seek(double time, bool absolute = false);
  void frameStep();
  void frameBackStep();
  void screenshot();

private:
};

#endif // PLAYER_H
