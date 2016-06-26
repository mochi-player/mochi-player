import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

FileDialog {
  id: openDialog

  title: qsTr("Open File(s)...")
  visible: true
  selectMultiple: true
  modality: Qt.ApplicationModal
  nameFilters: [
    "%0 (%1)".arg(qsTr("Video Files")).arg(app.videoFiletypes.join(" ")),
    "%0 (%1)".arg(qsTr("Audio Files")).arg(app.audioFiletypes.join(" ")),
    "%0 (*)".arg(qsTr("All Files"))
  ]

  onVisibleChanged: {
    if(openDialog.visible) {
      if(player.path != "")
        openDialog.folder = player.path;
      else
        openDialog.folder = app.pwd();
    }
  }

  onAccepted: player.load(openDialog.fileUrls);
}
