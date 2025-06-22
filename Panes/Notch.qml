// Main Notch
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
      focusable: false
      implicitHeight: screen.height * 0.65
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
        //Region {
        //  item: sideBarComponent
        //}
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
      
      // Sidebar component under work for now 
      //Components.SideBarComponent {
      //  id: sideBarComponent
      //  anchors.right: parent.right
      //  anchors.top: parent.top
      //  anchors.rightMargin: 20 * Dat.Globals.notchScale
      //}
    }
  }
}
