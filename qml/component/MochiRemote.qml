import QtQuick 2.7
import Mochi 1.0 as Mochi

Mochi.Remote {
  id: remote

  listen: true
  port: 8474

  // onAccept: window.acceptRemote
  // onExec: app.exec
  // onDisconnect: window.notifyDisconnect
}
