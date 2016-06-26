import QtQuick 2.7
import Mochi 1.0 as Mochi

Mochi.Update {
  id: update

  lastCheck: new Date()
  checkInterval: "startup" // never, startup, [interval in days]

  // onUpdated: window.notifyUpdated
}
