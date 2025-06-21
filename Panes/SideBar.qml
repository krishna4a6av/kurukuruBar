import QtQuick
import QtQuick.Layouts
import "../Data/" as Dat
import "../Widgets/" as Wid
RowLayout {
  // Center
  Rectangle {
    Layout.fillHeight: true
    Layout.fillWidth: true
    color: "transparent"

    Wid.TrayPill{
      implicitHeight: 20 * Dat.Globals.notchScale
      radius: 20 * Dat.Globals.notchScale
    }
  }

}

