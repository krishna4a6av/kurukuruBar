// CollapsedIndicatorComponent
import QtQuick
import QtQuick.Layouts
import "../../Data/" as Dat

Item {
  id: root
  
  // Properties for sizing
  readonly property int indicatorHeight: 20
  readonly property int indicatorWidth: 40
  readonly property int arrowSize: 12
  
  width: indicatorWidth
  height: indicatorHeight
  
  Rectangle {
    id: collapseIndicator
    
    anchors.fill: parent
    radius: 10
    color: Dat.Colors.withAlpha(Dat.Colors.surface_container, 0.6)
    border.color: Dat.Colors.withAlpha(Dat.Colors.outline, 0.3)
    border.width: 1
    
    // Only visible when collapsed
    visible: Dat.Globals.notchState === "COLLAPSED"
    opacity: Dat.Globals.notchState === "COLLAPSED" ? 1 : 0
    
    Behavior on opacity {
      NumberAnimation {
        duration: Dat.MaterialEasing.standardTime
        easing.bezierCurve: Dat.MaterialEasing.standard
      }
    }
    
    Behavior on color {
      ColorAnimation {
          duration: Dat.MaterialEasing.standardTime
      }
    }
    
        
    //Downward arrow icon
    Text {
      id: arrowIcon
      
      anchors.centerIn: parent
      font.family: "Material Symbols Outlined"
      font.pixelSize: root.arrowSize
      text: "" 
      color: Dat.Colors.on_surface
      
      Behavior on color {
        ColorAnimation {
            duration: Dat.MaterialEasing.standardTime
        }
      }
    }
    
    MouseArea {
      id: clickArea
      
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      
      onClicked: {
        Dat.Globals.notchState = "EXPANDED";
      }
      
      onContainsMouseChanged: {
        // Hover effect
        if (containsMouse) {
          collapseIndicator.color = Dat.Colors.withAlpha(Dat.Colors.surface_container_high, 0.9);
          collapseIndicator.scale = 1.05;
        } else {
          collapseIndicator.color = Dat.Colors.withAlpha(Dat.Colors.surface_container, 0.8);
          collapseIndicator.scale = 1.0;
        }
      }
    }
    
    // Smooth scale animation for hover effect
    Behavior on scale {
      NumberAnimation {
        duration: Dat.MaterialEasing.standardTime / 2
        easing.bezierCurve: Dat.MaterialEasing.standard
      }
    }
  }
}
