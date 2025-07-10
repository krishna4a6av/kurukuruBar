//this component is made to be expanded whe the popups are expaneded
//so that popup are focusable even when the bar is not expanded
import QtQuick
import "../../Data/" as Dat
import "../../Panes/" as Panes

Rectangle {
  id: popupComponent
  
  // Size properties
  readonly property int collapsedHeight: 0
  readonly property int expandedHeight: 320 * Dat.Globals.notchScale
  property string popupState: "EXPANDED"
  color: "transparent"
  width: parent.width * 0.7 * Dat.Globals.notchScale
  height: collapsedHeight
  
  // State management
  states: [
    State {
      name: "COLLAPSED"
      PropertyChanges {
        target: popupComponent
        height: popupComponent.collapsedHeight
        opacity: 0.8
      }
      PropertyChanges {
        target: popup
        opacity: 0
        visible: false
      }
    },
    State {
      name: "EXPANDED" 
      PropertyChanges {
        target: popupComponent
        height: popupComponent.expandedHeight
        opacity: 1
      }
      PropertyChanges {
        target: popup
        opacity: 1
        visible: true
      }
    }
  ]
  // Set initial state
  state: Dat.Globals.trayPopup?.visible ? "EXPANDED" : "COLLAPSED"
}
