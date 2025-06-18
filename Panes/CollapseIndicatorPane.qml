import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import "../Data/" as Dat

Scope {
  Variants {
    model: Quickshell.screens

    delegate: WlrLayershell {
      id: collapseNotch

      required property ShellScreen modelData

      anchors.left: true
      anchors.right: true
      anchors.top: true
      color: "transparent"
      exclusionMode: ExclusionMode.Ignore
      focusable: false
      implicitHeight: 22 // Just enough for the indicator
      layer: WlrLayer.Top
      namespace: "rexies.notch.quickshell.collapsed" 
      screen: modelData
      surfaceFormat.opaque: false

      mask: Region {
        Region {
          item: collapseIndicator
        }
      }

      Rectangle {
        id: collapseIndicator
 
        // Properties for sizing
        readonly property int indicatorHeight: 20
        readonly property int indicatorWidth: 40
        readonly property int arrowSize: 12
        
        // Positioning
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 2
        
        // Appearance
        width: indicatorWidth
        height: indicatorHeight
        radius: 10
        color: Dat.Colors.withAlpha(Dat.Colors.surface_container, 0.8)
        border.color: Dat.Colors.withAlpha(Dat.Colors.outline, 0.3)
        border.width: 1
        
        // Only visible when collapsed
        visible: Dat.Globals.notchState === "COLLAPSED"
        opacity: Dat.Globals.notchState === "COLLAPSED" ? 1 : 0
        
        // Smooth transitions
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
        
        // Downward arrow
        Canvas {
          id: arrowCanvas
            
          anchors.centerIn: parent
          width: collapseIndicator.arrowSize
          height: collapseIndicator.arrowSize / 2
          
          onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            
            // Set arrow color
            ctx.strokeStyle = Dat.Colors.onSurface;
            ctx.fillStyle = Dat.Colors.onSurface;
            ctx.lineWidth = 2;
            ctx.lineCap = "round";
            ctx.lineJoin = "round";
            
            // Draw downward arrow
            ctx.beginPath();
            ctx.moveTo(2, 2);                    // Top left
            ctx.lineTo(width / 2, height - 2);   // Bottom center
            ctx.lineTo(width - 2, 2);            // Top right
            ctx.stroke();
          }
        }
        
        // Mouse interaction
        MouseArea {
          id: clickArea
          
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          
          onClicked: {
            // Extend the collapsed bar to EXPANDED state | REST might lead to wierd behaviour
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
        
        // Optional: Subtle pulsing animation to draw attention
        SequentialAnimation {
          id: pulseAnimation
          running: collapseIndicator.visible
          loops: Animation.Infinite
          
          NumberAnimation {
            target: collapseIndicator
            property: "opacity"
            from: 1.0
            to: 0.7
            duration: 1500
            easing.bezierCurve: Dat.MaterialEasing.standard
          }
          
          NumberAnimation {
            target: collapseIndicator
            property: "opacity"
            from: 0.7
            to: 1.0
            duration: 1500
            easing.bezierCurve: Dat.MaterialEasing.standard
          }
          
          PauseAnimation {
            duration: 500
          }
        }
      }
    }
  }
}
