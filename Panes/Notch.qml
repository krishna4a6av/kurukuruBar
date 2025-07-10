// Its components are put in components folder where to finalize them is not decided by me yet :/
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import "../Data/" as Dat
import "../Panes/" as Panes
import "NotchComponents" as Components

Scope {
  
  Variants {
    
    model: Quickshell.screens
    
    delegate: WlrLayershell {
      id: notch

      required property ShellScreen modelData
      anchors.left: true
      anchors.right: true
      anchors.top: true
      color: "transparent"
      exclusionMode: ExclusionMode.Ignore
      focusable: true
      implicitHeight: screen.height
      layer: WlrLayer.Top
      namespace: "rexies.notch.quickshell"
      screen: modelData
      surfaceFormat.opaque: false
      
      mask: Region {
        Region {
          item: notchComponent
        }
        Region {
          item: notificationComponent
        }
        Region {
          item: collapsedIndicatorComponent
        }
        Region {
          item: popupComponent
        }
      }
      
      // Main notch component
      Components.NotchComponent {
        id: notchComponent

        anchors.horizontalCenter: parent.horizontalCenter

      }
      
      // Notification component
      Components.NotificationComponent {
        id: notificationComponent

        anchors.horizontalCenter: notchComponent.horizontalCenter
        anchors.top: notchComponent.bottom
        anchors.topMargin: 10 * Dat.Globals.notchScale

      }
      
      // Collapsed indicator component
      Components.CollapsedComponent {
        id: collapsedIndicatorComponent

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 2
      }
      
      // Keyboard shortcut handler
      Components.KeyboardComponent {
        id: keyboardComponent

        anchors.fill: parent
        enabled: true
        debugMode: false // Set to true for debugging screen on top right

      }
      
      // Sidebar component under work for now 
      Components.PopupComponent {
        id: popupComponent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
      }
    }
  }
}
