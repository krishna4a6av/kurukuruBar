import QtQuick
import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: brightnessButton
  color: Dat.Colors.surface_container_high
  
  // Array of brightness icons for different states
  property var brightnessIcons: ["", "", "", "", "", "", "", "", ""]
  
  // Function to get current brightness icon based on actual brightness percentage
  function getBrightnessIcon() {
    var currentPercent = Dat.Brightness.getCurrentBrightnessPercent()
    
    // Map percentage to icon index (0-8)
    var iconIndex = 0;
    if (currentPercent >= 90) iconIndex = 8;
    else if (currentPercent >= 80) iconIndex = 7;
    else if (currentPercent >= 70) iconIndex = 6;
    else if (currentPercent >= 60) iconIndex = 5;
    else if (currentPercent >= 50) iconIndex = 4;
    else if (currentPercent >= 40) iconIndex = 3;
    else if (currentPercent >= 30) iconIndex = 2;
    else if (currentPercent >= 20) iconIndex = 1;
    else iconIndex = 0;
    
    return brightnessIcons[iconIndex];
  }
  
  Text {
    anchors.centerIn: parent
    color: Dat.Colors.tertiary
    font.pointSize: 12 * Dat.Globals.notchScale
    text: brightnessButton.getBrightnessIcon()
  }
  
  Gen.MouseArea {
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    layerColor: Dat.Colors.tertiary
    onClicked: mevent => {
      switch (mevent.button) {
      case Qt.RightButton:
        Dat.Brightness.increase();
        break;
      case Qt.LeftButton:
        Dat.Brightness.decrease();
        break;
      }
    }
    onWheel: event => {
      if (event.angleDelta.y > 0) {
        Dat.Brightness.increase();
      } else {
        Dat.Brightness.decrease();
      }
    }
  }
}
