pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Notifications
import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: inboxRect
  property alias list: inbox
  
  ColumnLayout {
    anchors.fill: parent
    
    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      clip: true
      color: "transparent"
      
      ListView {
        id: inbox
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: (contentHeight < (300 * Dat.Globals.notchScale)) ? contentHeight : (300 * Dat.Globals.notchScale)
        model: Dat.NotifServer.notifications
        removeDisplaced: this.addDisplaced
        spacing: 5 * Dat.Globals.notchScale
        
        add: Transition {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardDecelTime
            easing.bezierCurve: Dat.MaterialEasing.standardDecel
            from: 1000 * Dat.Globals.notchScale
            property: "x"
          }
        }
        
        addDisplaced: Transition {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardTime
            easing.bezierCurve: Dat.MaterialEasing.standard
            properties: "x,y"
          }
        }
        
        delegate: Gen.Notification {
          required property Notification modelData
          color: Dat.Colors.surface_container
          notif: modelData
          radius: 20 * Dat.Globals.notchScale
          width: inbox.width
        }
        
        remove: Transition {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
            property: "x"
            to: 1000 * Dat.Globals.notchScale
          }
        }
      }
    }
  }
}
