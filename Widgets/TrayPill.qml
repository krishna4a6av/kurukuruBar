pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../Generics/" as Gen
import "../Data/" as Dat
import "../Widgets/" as Wid

Rectangle {
  id: trayPill
  
  property bool isAutoExpanded: Dat.Globals.notchState == "FULLY_EXPANDED"
  property bool isManuallyExpanded: false
  property bool isExpanded: isAutoExpanded || isManuallyExpanded
  property alias systemTray: systemTrayLoader.item
  
  color: "transparent"
  implicitWidth: isExpanded ? systemTrayLoader.width : collapsedButton.width
  implicitHeight: 22 * Dat.Globals.notchScale
  
  Rectangle {
    id: collapsedButton
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    
    visible: !trayPill.isExpanded
    
    color: Dat.Colors.primary
    radius: 12 * Dat.Globals.notchScale
    width: 40 * Dat.Globals.notchScale
    height: 21 * Dat.Globals.notchScale
    
    Text {
      id: iconText
      anchors.centerIn: parent
      text: ""
      font.pixelSize: 13 * Dat.Globals.notchScale
      color: Dat.Colors.on_primary
    }
    
    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      
      onClicked: {
        // Toggle manual expansion when clicked
        if (!trayPill.isExpanded) {
          trayPill.isManuallyExpanded = true
        } else {
          trayPill.isManuallyExpanded = false
          trayPill.isAutoExpanded = false
        }
      }
    }
  }
  
  // Expanded state - full system tray
  Loader {
    id: systemTrayLoader
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    
    active: trayPill.isExpanded
    visible: active
    
    sourceComponent: Component {
      SystemTray {
        id: systemTrayComponent
        
        // Add a MouseArea to handle clicks when expanded
        MouseArea {
          anchors.fill: parent
          propagateComposedEvents: true
          
          onClicked: function(mouse) {
            // Check if click is outside the tray items
            // You might want to add logic here to close when clicking empty areas
            mouse.accepted = false
          }
        }
      }
    }
  }
  
  MouseArea {
    anchors.fill: parent
    visible: trayPill.isExpanded
    z: -1 
    
    onClicked: {
      // Close when clicking outside tray items
      trayPill.isManuallyExpanded = false
    }
  }
}
