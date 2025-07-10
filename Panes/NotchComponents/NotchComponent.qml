
// Main NotchComponent

import QtQuick
import QtQuick.Layouts
import "../../Data/" as Dat
import "../../Panes/" as Panes

Rectangle {
  id: notchRect
  readonly property int baseHeight: 1 * Dat.Globals.notchScale
  readonly property int baseWidth: 200 * Dat.Globals.notchScale
  readonly property int restHeight: 30 * Dat.Globals.notchScale
  readonly property int restWidth: 720 * Dat.Globals.notchScale 
  readonly property int expandedHeight: 33 * Dat.Globals.notchScale
  readonly property int expandedWidth: 770 * Dat.Globals.notchScale
  readonly property int fullHeight: 220 * Dat.Globals.notchScale
  readonly property int fullWidth: this.expandedWidth
  property real notchScale: Dat.Globals.notchScale
  
  bottomLeftRadius: 20 * Dat.Globals.notchScale
  bottomRightRadius: 20 * Dat.Globals.notchScale
  clip: true
  color: Dat.Colors.withAlpha(Dat.Colors.background, (Dat.Globals.actWinName == "desktop" && Dat.Globals.notchState != "FULLY_EXPANDED") ? 0.79 : 0.89)
  state: Dat.Globals.notchState 
  
  Behavior on color {
    ColorAnimation {
      duration: Dat.MaterialEasing.standardTime
    }
  }
  
  states: [
    State {
      name: "REST"
      PropertyChanges {
        expandedPane.opacity: 0
        expandedPane.visible: false
        notchRect.height: notchRect.restHeight
        notchRect.opacity: 1
        notchRect.width: notchRect.restWidth
        topBar.opacity: 1
        topBar.visible: true
      }
    },
    State {
      name: "COLLAPSED"
      PropertyChanges {
        expandedPane.opacity: 0
        expandedPane.visible: false
        notchRect.height: notchRect.baseHeight
        notchRect.opacity: 0
        notchRect.width: notchRect.baseWidth
        topBar.opacity: 0
        topBar.visible: false
      }
    },
    State {
      name: "EXPANDED"
      PropertyChanges {
        expandedPane.opacity: 0
        expandedPane.visible: false
        notchRect.height: notchRect.expandedHeight
        notchRect.opacity: 1
        notchRect.width: notchRect.expandedWidth
        topBar.opacity: 1
        topBar.visible: true
      }
    },
    State {
      name: "FULLY_EXPANDED"
      PropertyChanges {
        expandedPane.opacity: 1
        expandedPane.visible: true
        notchRect.height: notchRect.fullHeight
        notchRect.opacity: 1
        notchRect.width: notchRect.fullWidth
        topBar.opacity: 1
        topBar.visible: true
      }
    }
  ]
  
  transitions: [
    Transition {
      from: "COLLAPSED"
      to: "REST"
      SequentialAnimation {
        PropertyAction {
          property: "visible"
          target: topBar
        }
        PropertyAction {
          property: "opacity"
          target: notchRect
        }
        ParallelAnimation {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardTime * 2
            easing.bezierCurve: Dat.MaterialEasing.standard
            property: "opacity"
            target: topBar
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.standardDecelTime
            easing.bezierCurve: Dat.MaterialEasing.standardDecel
            properties: "width, opacity, height"
            target: notchRect
          }
        }
      }
    },
    Transition {
      from: "REST"
      to: "COLLAPSED"
      SequentialAnimation {
        PropertyAction {
          property: "visible"
          target: topBar
        }
        PropertyAction {
          property: "opacity"
          target: notchRect
        }
        ParallelAnimation {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardTime * 2
            easing.bezierCurve: Dat.MaterialEasing.standard
            property: "opacity"
            target: topBar
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.standardDecelTime
            easing.bezierCurve: Dat.MaterialEasing.standardDecel
            properties: "width, opacity, height"
            target: notchRect
          }
        }
      }
    },
    Transition {
      from: "REST"
      to: "EXPANDED"
      SequentialAnimation {
        ParallelAnimation {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
            properties: "width, height"
            target: notchRect
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
            property: "opacity"
            target: topBar
          }
        }
        PropertyAction {
          property: "visible"
          target: topBar
        }
        PropertyAction {
          property: "opacity"
          target: notchRect
        }
      }
    },
    Transition {
      from: "EXPANDED"
      to: "REST"
      SequentialAnimation {
        ParallelAnimation {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
            properties: "width, height"
            target: notchRect
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
            property: "opacity"
            target: topBar
          }
        }
        PropertyAction {
          property: "visible"
          target: topBar
        }
        PropertyAction {
          property: "opacity"
          target: notchRect
        }
      }
    },
    Transition {
      from: "EXPANDED"
      to: "FULLY_EXPANDED"
      SequentialAnimation {
        PropertyAction {
          property: "visible"
          target: expandedPane
        }
        ParallelAnimation {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardDecelTime
            easing.bezierCurve: Dat.MaterialEasing.standardDecel
            property: "height"
            target: notchRect
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.standardTime * 3
            easing.bezierCurve: Dat.MaterialEasing.standard
            property: "opacity"
            target: expandedPane
          }
        }
      }
    },
    Transition {
      from: "FULLY_EXPANDED"
      to: "REST"
      SequentialAnimation {
        PropertyAction {
          property: "visible"
          target: expandedPane
        }
        ParallelAnimation {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardDecelTime
            easing.bezierCurve: Dat.MaterialEasing.standardDecel
            property: "height"
            target: notchRect
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.standardTime * 3
            easing.bezierCurve: Dat.MaterialEasing.standard
            property: "opacity"
            target: expandedPane
          }
        }
      }
    },
    Transition {
      id: fExpToExpTS
      from: "FULLY_EXPANDED"
      to: "EXPANDED"
      SequentialAnimation {
        ParallelAnimation {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardTime
            easing.bezierCurve: Dat.MaterialEasing.standard
            property: "height"
            target: notchRect
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.standardTime
            easing.bezierCurve: Dat.MaterialEasing.standard
            property: "opacity"
            target: expandedPane
          }
        }
        PropertyAction {
          property: "visible"
          target: expandedPane
        }
      }
    },
    Transition {
      from: "COLLAPSED"
      reversible: true
      to: "FULLY_EXPANDED"
      NumberAnimation {
        duration: Dat.MaterialEasing.emphasizedTime
        easing.bezierCurve: Dat.MaterialEasing.emphasized
        properties: "height, opacity, width"
        target: notchRect
      }
    }
  ]
  
  MouseArea {
    id: notchArea
    property real prevY: 0
    readonly property real sensitivity: 5 * Dat.Globals.notchScale
    property bool tracing: false
    property real velocity: 0
    
    function expandOrRest() {
      if (fExpToExpTS.running) {
        return;
      }
      if (Dat.Globals.notchState == "FULLY_EXPANDED" || Dat.Globals.reservedShell) {
        return;
      }
      if (Dat.Globals.notchState == "COLLAPSED" ) {
        return;
      }
      if (notchArea.containsMouse) {
        Dat.Globals.notchState = "EXPANDED";
      } else {
        //ensures notch is does not change state when the popup is open
        if (Dat.Globals.trayPopup?.visible){
          return;
        }else{
          Dat.Globals.notchState = "REST";
        }
      }
    }
    
    anchors.fill: parent
    hoverEnabled: true
    Component.onCompleted: fExpToExpTS.runningChanged.connect(notchArea.expandOrRest)
    
    onContainsMouseChanged: {
      Dat.Globals.notchHovered = notchArea.containsMouse;
      notchArea.expandOrRest();
    }
    
    onPositionChanged: mevent => {
      if (!tracing) {
        return;
      }
      notchArea.velocity = notchArea.prevY - mevent.y;
      notchArea.prevY = mevent.y;
      
      if (velocity < -notchArea.sensitivity) {
        Dat.Globals.notchState = "FULLY_EXPANDED";
        notchArea.tracing = false;
        notchArea.velocity = 0;
      }
      
      if (velocity > notchArea.sensitivity) {
        Dat.Globals.notchState = "EXPANDED";
        notchArea.tracing = false;
        notchArea.velocity = 0;
      }
    }
    
    onPressed: mevent => {
      notchArea.tracing = true;
      notchArea.prevY = mevent.y;
      notchArea.velocity = 0;
    }
    
    onReleased: mevent => {
      notchArea.tracing = true;
      notchArea.velocity = 0;
    }
    
    ColumnLayout {
      anchors.centerIn: parent
      anchors.fill: parent
      spacing: 0
      
      Panes.TopBar {
        id: topBar
        Layout.alignment: Qt.AlignTop
        Layout.fillWidth: true
        Layout.maximumHeight: notchRect.expandedHeight
        Layout.minimumHeight: notchRect.expandedHeight - (10 * Dat.Globals.notchScale)
      }
      
      Panes.ExpandedPane {
        id: expandedPane
        Layout.fillHeight: true
        Layout.fillWidth: true
      }
    }
  }
}

