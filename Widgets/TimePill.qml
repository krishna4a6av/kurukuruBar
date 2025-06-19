import QtQuick
import "../Data/" as Dat
import "../Generics/" as Gen

Text {
  id: timeText
  anchors.centerIn: parent
  color: Dat.Colors.secondary
  font.pointSize: 11 * Dat.Globals.notchScale
  text: Qt.formatDateTime(Dat.Clock?.date, "h:mm:ss AP")
  
  Gen.MouseArea {
    anchors.centerIn: parent
    anchors.fill: null
    height: 20 * Dat.Globals.notchScale
    layerColor: Dat.Colors.secondary
    layerRadius: 20 * Dat.Globals.notchScale
    width: timeText.contentWidth + (12 * Dat.Globals.notchScale)
    onClicked: {
      if (Dat.Globals.notchState == "FULLY_EXPANDED" && Dat.Globals.swipeIndex == 1) {
        Dat.Globals.notchState = "EXPANDED";
      } else {
        Dat.Globals.notchState = "FULLY_EXPANDED";
        Dat.Globals.swipeIndex = 1;
      }
    }
  }
}
