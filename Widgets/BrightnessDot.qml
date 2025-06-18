import QtQuick
import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: brightnessButton
  color: Dat.Colors.surface_container_high
  
  // Array of brightness icons for different states
  property var brightnessIcons: ["","", "", "", "", "", "", "", "", ""]
  
  // Track brightness level internally
  property int brightnessLevel: 4 // Start at middle brightness (index 4)
  
  // Function to get current brightness icon
  function getBrightnessIcon() {
    return brightnessIcons[brightnessLevel];
  }
  
  Text {
    anchors.centerIn: parent
    color: Dat.Colors.tertiary
    font.pointSize: 12
    text: brightnessButton.getBrightnessIcon()
  }
  
  Gen.MouseArea {
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    layerColor: Dat.Colors.tertiary
    onClicked: mevent => {
      switch (mevent.button) {
      case Qt.RightButton:
        if (brightnessButton.brightnessLevel < 9) {
          brightnessButton.brightnessLevel++;
        }
        Dat.Brightness.increase();
        break;
      case Qt.LeftButton:
        if (brightnessButton.brightnessLevel > 0) {
          brightnessButton.brightnessLevel--;
        }
        Dat.Brightness.decrease();
        break;
      }
    }
    onWheel: event => {
      if (event.angleDelta.y > 0) {
        if (brightnessButton.brightnessLevel < 8) {
          brightnessButton.brightnessLevel++;
        }
        Dat.Brightness.increase();
      } else {
        if (brightnessButton.brightnessLevel > 0) {
          brightnessButton.brightnessLevel--;
        }
        Dat.Brightness.decrease();
      }
    }
  }
}
