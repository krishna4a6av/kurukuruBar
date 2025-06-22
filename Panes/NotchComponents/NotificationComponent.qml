
//notification system
import QtQuick
import QtQuick.Layouts
import "../../Data/" as Dat
import "../../Panes/" as Panes

Rectangle {
  id: notificationRect
  readonly property int baseHeight: 0
  readonly property int baseWidth: 0
  readonly property int fullWidth: 500 * Dat.Globals.notchScale
  readonly property int popupHeight: 100 * Dat.Globals.notchScale
  readonly property int popupWidth: 430 * Dat.Globals.notchScale
  
  color: Dat.Colors.surface
  radius: 20 * Dat.Globals.notchScale
  state: Dat.Globals.notifState
  
  states: [
    State {
      name: "HIDDEN"
      PropertyChanges {
        inboxRect.opacity: 0
        inboxRect.visible: false
        notificationRect.color: "transparent"
        notificationRect.implicitHeight: 0
        notificationRect.implicitWidth: 0
        notificationRect.visible: false
        popupRect.opacity: 0
        popupRect.visible: false
      }
    },
    State {
      name: "POPUP"
      PropertyChanges {
        inboxRect.opacity: 0
        inboxRect.visible: false
        notificationRect.color: Dat.Colors.surface_container
        notificationRect.implicitHeight: notificationRect.popupHeight
        notificationRect.implicitWidth: notificationRect.popupWidth
        notificationRect.visible: true
        popupRect.opacity: 1
        popupRect.visible: true
      }
    },
    State {
      name: "INBOX"
      PropertyChanges {
        inboxRect.opacity: 1
        inboxRect.visible: true
        notificationRect.color: "transparent"
        notificationRect.implicitHeight: (Dat.NotificationServer.notifCount == 0) ? 0 : inboxRect.list.height
        notificationRect.implicitWidth: notificationRect.fullWidth
        notificationRect.visible: true
        popupRect.opacity: 0
        popupRect.visible: false
      }
    }
  ]
  
  transitions: [
    Transition {
      from: "HIDDEN"
      to: "INBOX"
      SequentialAnimation {
        PropertyAction {
          properties: "visible, implicitWidth"
          targets: [inboxRect, notificationRect]
        }
        ParallelAnimation {
          ColorAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standard
            property: "color"
            target: notificationRect
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
            property: "implicitHeight"
            target: notificationRect
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
            property: "opacity"
            target: inboxRect
          }
        }
      }
    },
    Transition {
      from: "INBOX"
      to: "HIDDEN"
      SequentialAnimation {
        ParallelAnimation {
          ColorAnimation {
            duration: Dat.MaterialEasing.standardAccelTime * 3
            easing.bezierCurve: Dat.MaterialEasing.standard
            property: "color"
            target: notificationRect
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
            property: "implicitHeight"
            target: notificationRect
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
            property: "opacity"
            target: inboxRect
          }
        }
        PropertyAction {
          properties: "visible, implicitWidth"
          targets: [inboxRect, notificationRect]
        }
      }
    },
    Transition {
      from: "POPUP"
      to: "INBOX"
      ParallelAnimation {
        ColorAnimation {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.bezierCurve: Dat.MaterialEasing.emphasized
          property: "color"
          target: notificationRect
        }
        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.bezierCurve: Dat.MaterialEasing.emphasized
          properties: "implicitWidth, implicitHeight"
          target: notificationRect
        }
        PropertyAction {
          property: "opacity"
          target: popupRect
        }
        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.bezierCurve: Dat.MaterialEasing.emphasized
          property: "opacity"
          target: inboxRect
        }
        PropertyAction {
          property: "visible"
          targets: [popupRect, inboxRect]
        }
      }
    },
    Transition {
      from: "INBOX"
      to: "POPUP"
      ParallelAnimation {
        ColorAnimation {
          duration: Dat.MaterialEasing.emphasizedTime * 1.5
          easing.bezierCurve: Dat.MaterialEasing.emphasized
          property: "color"
          target: notificationRect
        }
        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.bezierCurve: Dat.MaterialEasing.emphasized
          properties: "implicitWidth, implicitHeight"
          target: notificationRect
        }
        SequentialAnimation {
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedTime / 2
            easing.bezierCurve: Dat.MaterialEasing.emphasized
            property: "opacity"
            target: inboxRect
          }
          PropertyAction {
            property: "visible"
            targets: [popupRect, inboxRect]
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedTime / 2
            easing.bezierCurve: Dat.MaterialEasing.emphasized
            property: "opacity"
            target: popupRect
          }
        }
      }
    },
    Transition {
      from: "HIDDEN"
      to: "POPUP"
      SequentialAnimation {
        PropertyAction {
          property: "visible"
          targets: [popupRect, notificationRect]
        }
        ParallelAnimation {
          ColorAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standard
            property: "color"
            target: notificationRect
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
            properties: "implicitWidth, implicitHeight"
            target: notificationRect
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
            properties: "opacity"
            target: popupRect
          }
        }
      }
    },
    Transition {
      from: "POPUP"
      to: "HIDDEN"
      SequentialAnimation {
        ParallelAnimation {
          ColorAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standard
            property: "color"
            target: notificationRect
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
            properties: "implicitWidth, implicitHeight"
            target: notificationRect
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
            properties: "opacity"
            target: popupRect
          }
        }
        PropertyAction {
          property: "visible"
          targets: [popupRect, notificationRect]
        }
      }
    }
  ]
  
  Component.onCompleted: {
    Dat.Globals.notchStateChanged.connect(() => {
      switch (Dat.Globals.notchState) {
      case "FULLY_EXPANDED":
        Dat.Globals.notifState = "INBOX";
        break;
      default:
        Dat.Globals.notifState = (!popupRect?.closed ?? false) ? "POPUP" : "HIDDEN";
        break;
      }
    });
  }
  
  ColumnLayout {
    anchors.fill: parent
    
    Panes.PopupPane {
      id: popupRect
      Layout.fillHeight: true
      Layout.fillWidth: true
      color: "transparent"
      radius: notificationRect.radius
    }
    
    Panes.InboxPane {
      id: inboxRect
      Layout.fillHeight: true
      Layout.fillWidth: true
      color: "transparent"
      radius: notificationRect.radius
    }
  }
}

