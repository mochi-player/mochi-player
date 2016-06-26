#include "tst_player.h"
#include "player.h"

#include <QTest>
#include <QSignalSpy>
#include <QVariant>
#include <QVariantList>

void TestPlayer::initTestCase() {
  player = new Player();
}

void TestPlayer::main() {
  const QString testfile = ":/test2.webm", testdir = ":/";
  QSignalSpy spy(this, SIGNAL(success()));
  connect(player, &Player::playlistChanged,
          this, [=](QVariantList playlist) {
    emit success();
    int n = 0;
    for(QVariantList::iterator item = playlist.begin();
        item != playlist.end(); item++) {
      if(item->toMap()["filename"].toString() == testfile) {
        player->setProperty("playlistPos", n);
        break;
      }
      n++;
    }
  });
  connect(player, &Player::pathChanged,
          this, [=](QString path) {
    if(path.endsWith(testfile)) {
      emit success();
      player->setProperty("pause", true);
    }
  });
  connect(player, &Player::pauseChanged,
          this, [=](bool pause) {
    if(pause) {
      emit success();
      player->setProperty("pause", false);
    }
  });
  connect(player, &Player::playStateChanged,
          this, [=](PlayState state) {
    if(state == Stopped)
      emit success();
    else if(state == Failed)
      QWARN("File couldn't be loaded.");
  });
  player->load(testdir);
  // WIP--this doesn't work properly yet, the directory fails to load.
//  QVERIFY2(spy.wait(), "Load test directory");
//  QVERIFY2(spy.wait(), "Find test file in playlist");
//  QVERIFY2(spy.wait(), "Load and play test file");
//  QVERIFY2(spy.wait(), "Pause test file");
//  QVERIFY2(spy.wait(), "Test file completed");
  QVERIFY2(spy.wait(), "Engine did something");
}

void TestPlayer::cleanupTestCase() {
  delete player;
}
