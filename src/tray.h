#ifndef TRAY_H
#define TRAY_H

#include <QObject>
#include <QSystemTrayIcon>

#include "property.h"
#include "menu.h"

class Tray : public QSystemTrayIcon {
  Q_OBJECT
  Q_CLASSINFO("Version", "2.1.0")

  M_PROPERTY(bool, visible, USER true)
  M_PROPERTY(QString, icon, WRITE setIcon)
  M_PROPERTY(Menu*, menu, WRITE setMenu)

public:
  explicit Tray(QObject *parent = nullptr);

protected slots:
  void setIcon(const QString&);
  void setMenu(Menu *menu);

private:
  QMenu contextMenu;

signals:
};

#endif // TRAY_H
