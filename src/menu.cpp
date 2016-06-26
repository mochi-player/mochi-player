#include "menu.h"

MenuItem::MenuItem(QQuickItem *parent):QQuickItem(parent) {}

QAction *MenuItem::addTo(QPointer<QMenu> menu) const {
  return menu->addAction(
        QIcon(icon),
        text,
        this, SIGNAL(triggered(bool)),
        QKeySequence(shortcut));
}

MenuSeparator::MenuSeparator(QQuickItem *parent):QQuickItem(parent) {}

QAction *MenuSeparator::addTo(QPointer<QMenu> menu) const {
  return menu->addSeparator();
}

Menu::Menu(QQuickItem *parent):QQuickItem(parent) {}

QAction *Menu::addTo(QPointer<QMenu> parent) const {
  QPointer<QMenu> self(new QMenu(title));
  Menu *menu; MenuItem *menuItem; MenuSeparator *menuSeparator;
  for(QList<QObject*>::const_iterator item = children().constBegin();
      item != children().constEnd(); item++) {
    if((menu = qobject_cast<Menu*>(*item)))
      menu->addTo(self);
    else if((menuItem = qobject_cast<MenuItem*>(*item)))
      menuItem->addTo(self);
    else if((menuSeparator = qobject_cast<MenuSeparator*>(*item)))
      menuSeparator->addTo(self);
  }
  return parent->addMenu(self);
}
