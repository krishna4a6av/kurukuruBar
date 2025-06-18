pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "../Generics/" as Gen
import "../Data/" as Dat
import "../Widgets/" as Wid


Item {
  id: directTray
  
  property bool expanded: false
  property alias stack: dummyStack
  
  implicitWidth: trayRow.implicitWidth
  implicitHeight: 32
  
  // Dummy StackView for TrayItem compatibility
  StackView {
    id: dummyStack
    visible: false
  }
  
  // Collapsed state - shows tray items directly in top bar
  RowLayout {
    id: trayRow
    
    anchors.centerIn: parent
    spacing: 6
    visible: !expanded
    
    Repeater {
      model: ScriptModel {
        values: [...SystemTray.items.values]
      }
      
      Rectangle {
        Layout.preferredWidth: 28
        Layout.preferredHeight: 28
        radius: 6
        color: trayItemMouseArea.containsMouse ? 
               Qt.rgba(Dat.Colors.surface_variant.r, Dat.Colors.surface_variant.g, Dat.Colors.surface_variant.b, 0.3) : 
               "transparent"
        
        Wid.TrayItem {
          anchors.centerIn: parent
          stack: directTray.stack
          width: 20
          height: 20
        }
        
        MouseArea {
          id: trayItemMouseArea
          anchors.fill: parent
          hoverEnabled: true
          
          onClicked: {
            directTray.expanded = true
          }
        }
      }
    }
    
    // Expand button (optional - shows when there are multiple items)
    Rectangle {
      Layout.preferredWidth: 20
      Layout.preferredHeight: 28
      radius: 6
      color: expandMouseArea.containsMouse ? 
             Qt.rgba(Dat.Colors.surface_variant.r, Dat.Colors.surface_variant.g, Dat.Colors.surface_variant.b, 0.3) : 
             "transparent"
      visible: SystemTray.items.values.length > 3
      
      Text {
        anchors.centerIn: parent
        text: "⋯"
        color: Dat.Colors.on_surface
        font.pixelSize: 12
        rotation: 90
      }
      
      MouseArea {
        id: expandMouseArea
        anchors.fill: parent
        hoverEnabled: true
        
        onClicked: {
          directTray.expanded = true
        }
      }
    }
  }
  
  // Expanded dropdown
  Rectangle {
    id: expandedPanel
    
    anchors.top: parent.bottom
    anchors.topMargin: 8
    anchors.right: parent.right
    
    width: expanded ? 280 : 0
    height: expanded ? expandedContent.implicitHeight + 20 : 0
    
    color: Dat.Colors.surface_container
    radius: 12
    z: 1000
    
    // Shadow
    Rectangle {
      anchors.fill: parent
      anchors.margins: -2
      color: "#15000000"
      radius: parent.radius + 2
      visible: expanded
      z: -1
    }
    
    // Smooth animations
    Behavior on width {
      NumberAnimation {
        duration: Dat.MaterialEasing.emphasizedTime
        easing.bezierCurve: Dat.MaterialEasing.emphasized
      }
    }
    
    Behavior on height {
      NumberAnimation {
        duration: Dat.MaterialEasing.emphasizedTime
        easing.bezierCurve: Dat.MaterialEasing.emphasized
      }
    }
    
    ColumnLayout {
      id: expandedContent
      
      anchors.centerIn: parent
      spacing: 12
      visible: expanded
      
      // Header
      RowLayout {
        Layout.fillWidth: true
        Layout.margins: 10
        
        Text {
          text: "System Tray"
          color: Dat.Colors.on_surface
          font.pixelSize: 14
          font.weight: Font.Medium
          Layout.fillWidth: true
        }
        
        Rectangle {
          width: 24
          height: 24
          radius: 12
          color: closeMouseArea.containsMouse ? Dat.Colors.error_container : Dat.Colors.surface_variant
          
          Text {
            anchors.centerIn: parent
            text: "✕"
            color: closeMouseArea.containsMouse ? Dat.Colors.on_error_container : Dat.Colors.on_surface_variant
            font.pixelSize: 10
          }
          
          MouseArea {
            id: closeMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: directTray.expanded = false
          }
        }
      }
      
      // Tray items grid
      GridLayout {
        columns: Math.min(5, SystemTray.items.values.length)
        columnSpacing: 10
        rowSpacing: 10
        Layout.alignment: Qt.AlignCenter
        Layout.margins: 10
        
        Repeater {
          model: ScriptModel {
            values: [...SystemTray.items.values]
          }
          
          Rectangle {
            Layout.preferredWidth: 44
            Layout.preferredHeight: 44
            radius: 8
            color: gridItemMouseArea.containsMouse ? 
                   Qt.lighter(Dat.Colors.surface_variant, 1.1) : 
                   Dat.Colors.surface_variant
            
            Wid.TrayItem {
              anchors.centerIn: parent
              stack: directTray.stack
              width: 28
              height: 28
              index: model.index
              modelData: modelData
            }
            
            MouseArea {
              id: gridItemMouseArea
              anchors.fill: parent
              hoverEnabled: true
            }
          }
        }
      }
    }
  }
  
  // Manual close only - click the X button to close
  // Removed automatic click-outside-to-close to avoid parent reference issues
}
