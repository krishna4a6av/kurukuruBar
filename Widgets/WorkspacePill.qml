import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: root
  clip: true
  color: Dat.Colors.primary_container
  height: 20 * Dat.Globals.notchScale
  implicitWidth: workRow.width + (8 * Dat.Globals.notchScale)
  radius: 20 * Dat.Globals.notchScale
  
  Behavior on implicitWidth {
    NumberAnimation {
      duration: Dat.MaterialEasing.standardDecelTime
      easing.bezierCurve: Dat.MaterialEasing.standardDecel
    }
  }
  
  RowLayout {
    id: workRow
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.top: parent.top
    spacing: 5 * Dat.Globals.notchScale
    
    Rectangle {
      color: Dat.Colors.primary
      implicitHeight: 20 * Dat.Globals.notchScale
      implicitWidth: 20 * Dat.Globals.notchScale
      radius: 20 * Dat.Globals.notchScale
      
      Text {
        id: workspaceNumText
        anchors.centerIn: parent
        color: Dat.Colors.on_primary
        font.pointSize: 10 * Dat.Globals.notchScale
        text: Hyprland.focusedWorkspace?.id ?? "~"
      }
    }
    
    Text {
      id: windowNameText
      readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
      Layout.maximumWidth: 100 * Dat.Globals.notchScale
      color: Dat.Colors.on_primary_container
      elide: Text.ElideRight
      font.pointSize: 11 * Dat.Globals.notchScale
      text: {
        const full = Dat.Globals.actWinName;
        // Example: "org.kde.dolphin" => "Dolphin"
        if (!full) return "";
        const parts = full.split(".");
        const raw = parts[parts.length - 1];
        return raw.charAt(0).toUpperCase() + raw.slice(1);
      }
    }
  }
  
  Gen.MouseArea {
    layerColor: Dat.Colors.on_primary_container
    layerRadius: 20 * Dat.Globals.notchScale
    onClicked: {
      if (Dat.Globals.notchState == "FULLY_EXPANDED" && Dat.Globals.swipeIndex == 2) {
        Dat.Globals.notchState = "EXPANDED";
      } else {
        Dat.Globals.notchState = "FULLY_EXPANDED";
        Dat.Globals.swipeIndex = 2;
      }
    }
    onWheel: event => {
        if (event.angleDelta.y < 0 || Hyprland.focusedWorkspace?.id > 1)
            Hyprland.dispatch(`workspace r${event.angleDelta.y > 0 ? "-" : "+"}1`);
    }
  }
}
