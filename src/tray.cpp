#include "tray.h"

#include <QIcon>

Tray::Tray(QObject *parent):
  QSystemTrayIcon(parent) {
  setObjectName("tray");
  QSystemTrayIcon::setContextMenu(&contextMenu);
}

void Tray::setIcon(const QString &icon) {
  QSystemTrayIcon::setIcon(QIcon(icon));
  emit iconChanged(icon);
}

void Tray::setMenu(Menu *menu) {
  menu->addTo(&contextMenu);
  emit menuChanged(menu);
}
