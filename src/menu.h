#ifndef MENU_H
#define MENU_H

#include <QObject>
#include <QQmlListProperty>
#include <QMenu>
#include <QJSValue>
#include <QAction>
#include <QPointer>
#include <QQuickItem>

#include "property.h"

class MenuItem : public QQuickItem {
  Q_OBJECT
  M_PROPERTY(QString, icon,)
  M_PROPERTY(QString, text,)
  M_PROPERTY(QString, shortcut,)

public:
  MenuItem(QQuickItem *parent = nullptr);
  QAction *addTo(QPointer<QMenu> menu) const;

signals:
  void triggered(bool checked);
};

class MenuSeparator : public QQuickItem {
  Q_OBJECT
public:
  MenuSeparator(QQuickItem *parent = nullptr);
  QAction *addTo(QPointer<QMenu> menu) const;
};

class Menu : public QQuickItem {
  Q_OBJECT
  M_PROPERTY(QString, title,)

public:
  Menu(QQuickItem *parent = nullptr);
  QAction *addTo(QPointer<QMenu> menu) const;
};


#endif // MENU_H
