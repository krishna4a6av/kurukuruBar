// Components/SideBarComponent.qml - collapsible sidebar with hover expand
// just added the tray elements in this for now, we'll see how this goes.
import QtQuick
import "../../Data/" as Dat
import "../../Panes/" as Panes

Rectangle {
  id: sideBarComponent
  
  // Size properties
  readonly property int collapsedHeight: 5 * Dat.Globals.notchScale
  readonly property int expandedHeight: 38 * Dat.Globals.notchScale
  property string sideBarState: "COLLAPSED"
  
  // Styling
  bottomLeftRadius: 20 * Dat.Globals.notchScale
  bottomRightRadius: 20 * Dat.Globals.notchScale
  color: Dat.Colors.withAlpha(Dat.Colors.background, 0)
  width: parent.width * 0.25
  height: collapsedHeight
  
  // State management
  states: [
    State {
      name: "COLLAPSED"
      PropertyChanges {
        target: sideBarComponent
        height: sideBarComponent.collapsedHeight
        opacity: 0.8
      }
      PropertyChanges {
        target: sideBar
        opacity: 0
        visible: false
      }
    },
    State {
      name: "EXPANDED" 
      PropertyChanges {
        target: sideBarComponent
        height: sideBarComponent.expandedHeight
        opacity: 1
      }
      PropertyChanges {
        target: sideBar
        opacity: 1
        visible: true
      }
    }
  ]
  
  // Smooth transitions
  transitions: [
    Transition {
      from: "COLLAPSED"
      to: "EXPANDED"
      SequentialAnimation {
        PropertyAction {
          target: sideBar
          property: "visible"
        }
        ParallelAnimation {
          NumberAnimation {
            target: sideBarComponent
            properties: "height, opacity"
            duration: Dat.MaterialEasing.standardTime
            easing.bezierCurve: Dat.MaterialEasing.standard
          }
          NumberAnimation {
            target: sideBar
            property: "opacity"
            duration: Dat.MaterialEasing.standardTime * 1.5
            easing.bezierCurve: Dat.MaterialEasing.standard
          }
        }
      }
    },
    Transition {
      from: "EXPANDED"
      to: "COLLAPSED"
      SequentialAnimation {
        ParallelAnimation {
          NumberAnimation {
            target: sideBarComponent
            properties: "height, opacity"
            duration: Dat.MaterialEasing.standardTime
            easing.bezierCurve: Dat.MaterialEasing.standard
          }
          NumberAnimation {
            target: sideBar
            property: "opacity"
            duration: Dat.MaterialEasing.standardTime * 0.7
            easing.bezierCurve: Dat.MaterialEasing.standard
          }
        }
        PropertyAction {
          target: sideBar
          property: "visible"
        }
      }
    }
  ]
  
  // Mouse interaction area
  MouseArea {
    id: sideBarArea
    anchors.fill: parent
    hoverEnabled: true
    
    onContainsMouseChanged: {
      if (containsMouse) {
        sideBarComponent.sideBarState = "EXPANDED"
      } else {
        sideBarComponent.sideBarState = "COLLAPSED"
      }
    }
  }
  
  Panes.SideBar {
    id: sideBar
    anchors.fill: parent
    anchors.leftMargin: 10 * Dat.Globals.notchScale
    anchors.rightMargin: 10 * Dat.Globals.notchScale
    anchors.topMargin: 10 * Dat.Globals.notchScale
    anchors.bottomMargin: 10 * Dat.Globals.notchScale
  }
  
  // Set initial state
  state: sideBarState
}
