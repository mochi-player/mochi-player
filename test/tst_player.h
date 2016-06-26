#ifndef TST_PLAYER_H
#define TST_PLAYER_H

#include <QObject>

class Player;
class TestPlayer : public QObject {
  Q_OBJECT
private slots:
  void initTestCase();

  void main();

  void cleanupTestCase();

private:
  Player *player;

signals:
  void success();
};

#endif // TST_PLAYER_H
