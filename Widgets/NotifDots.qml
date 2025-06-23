import QtQuick
import QtQuick.Layouts
import "../Data/" as Dat
import "../Widgets/" as Wid
import "../Generics/" as Gen

Rectangle {
  implicitWidth: dotContainer.implicitWidth + 10 * Dat.Globals.notchScale
  
  RowLayout {
    id: dotContainer
    anchors.centerIn: parent
    spacing: 5 * Dat.Globals.notchScale
    
    Rectangle {
      color: "transparent"
      implicitHeight: this.implicitWidth
      implicitWidth: 22 * Dat.Globals.notchScale
      radius: this.implicitWidth
      
      Gen.MatIcon {
        id: trashIcon
        property bool clearable: Dat.NotifServer.notifCount > 0
        anchors.centerIn: parent
        color: (clearable) ? Dat.Colors.on_surface : Dat.Colors.on_surface_variant
        fill: (clearable) ? 1 : 0
        font.pixelSize: 14 * Dat.Globals.notchScale
        icon: "󰆴"
      }
      
      Gen.MouseArea {
        layerColor: trashIcon.color
        visible: trashIcon.clearable
        onClicked: Dat.NotifServer.clearNotifs()
      }
    }
    
    Gen.ToggleButton {
      active: !Dat.NotifServer.dndEnabled
      activeColor: Dat.Colors.secondary
      activeIconColor: Dat.Colors.on_secondary
      implicitHeight: this.implicitWidth
      implicitWidth: 22 * Dat.Globals.notchScale
      radius: this.implicitWidth
      
      icon {
        icon: (this.active) ? "󰂚" : "󰂛"
        font.pixelSize: 14 * Dat.Globals.notchScale
      }
      
      mArea {
        onClicked: Dat.NotifServer.dndEnabled = !Dat.NotifServer.dndEnabled
      }
    }
    
    Gen.ToggleButton {
      id: idleButton
      active: Dat.SessionActions.idleInhibited
      activeColor: Dat.Colors.secondary
      activeIconColor: Dat.Colors.on_secondary
      implicitHeight: this.implicitWidth
      implicitWidth: 22 * Dat.Globals.notchScale
      radius: this.implicitWidth
      
      icon {
        icon: "󰅶"
        font.pixelSize: 14 * Dat.Globals.notchScale
      }
      
      mArea {
        onClicked: Dat.SessionActions.toggleIdle()
      }
    }
  }
}
