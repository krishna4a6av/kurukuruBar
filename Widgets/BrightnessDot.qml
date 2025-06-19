import QtQuick
import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: brightnessButton
  color: Dat.Colors.surface_container_high
  
  // Array of brightness icons for different states
  property var brightnessIcons: ["", "", "", "", "", "", "", "", ""]
  
  // Track brightness level internally
  property int brightnessLevel: 4 // Start at middle brightness (index 4)
  
  // Track click count for alternating behavior
  property int clickCount: 0
  
  // Track scroll count for alternating behavior
  property int scrollCount: 0
  
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
        brightnessButton.clickCount++;
        if (brightnessButton.clickCount % 2 === 0 && brightnessButton.brightnessLevel < 9) {
          brightnessButton.brightnessLevel++;
        }
        Dat.Brightness.increase();
        break;
      case Qt.LeftButton:
        brightnessButton.clickCount++;
        if (brightnessButton.clickCount % 2 === 0 && brightnessButton.brightnessLevel > 0) {
          brightnessButton.brightnessLevel--;
        }
        Dat.Brightness.decrease();
        break;
      }
    }
    onWheel: event => {
      if (event.angleDelta.y > 0) {
        brightnessButton.scrollCount++;
        if (brightnessButton.scrollCount % 2 === 0 && brightnessButton.brightnessLevel < 8) {
          brightnessButton.brightnessLevel++;
        }
        Dat.Brightness.increase();
      } else {
        brightnessButton.scrollCount++;
        if (brightnessButton.scrollCount % 2 === 0 && brightnessButton.brightnessLevel > 0) {
          brightnessButton.brightnessLevel--;
        }
        Dat.Brightness.decrease();
      }
    }
  }
}
