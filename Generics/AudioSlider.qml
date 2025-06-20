pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: root
  property color bgColor: node?.isStream ? Dat.Colors.tertiary_container : Dat.Colors.primary_container
  property color fgColor: node?.isStream ? Dat.Colors.tertiary : Dat.Colors.primary
  required property PwNode node
  color: "transparent"
  implicitHeight: 42 * Dat.Globals.notchScale
  
  ColumnLayout {
    anchors.fill: parent
    spacing: 4 * Dat.Globals.notchScale
    
    RowLayout {
      Layout.fillHeight: true
      Layout.fillWidth: true
      spacing: 8 * Dat.Globals.notchScale
      
      Item {
        Layout.fillHeight: true
        Layout.fillWidth: true
        
        Text {
          anchors.fill: parent
          color: Dat.Colors.on_surface
          elide: Text.ElideRight
          font.pointSize: 10 * Dat.Globals.notchScale
          text: (root.node?.isStream ? root.node?.name : (nameArea.containsMouse) ? root.node?.description : (root.node?.nickname) ? root.node?.nickname : root.node?.description) ?? "Unidentified"
          verticalAlignment: Text.AlignVCenter
          
          MouseArea {
            id: nameArea
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            hoverEnabled: true
            width: Math.min(parent.contentWidth, parent.width)
          }
        }
      }
      
      Gen.ToggleButton {
        id: icon
        Layout.fillHeight: true
        active: (root.node?.isSink) ? root.node == Pipewire.defaultAudioSink : root.node == Pipewire.defaultAudioSource
        implicitWidth: this.height
        radius: this.height
        visible: !root.node?.isStream
        
        icon {
          color: Dat.Colors.primary
          font.pointSize: 10 * Dat.Globals.notchScale
          icon: (!root.node?.isSink) ? "" : ""
        }
        
        mArea {
          onClicked: {
            if (root.node?.isSink) {
              Pipewire.preferredDefaultAudioSink = root.node;
            } else {
              Pipewire.preferredDefaultAudioSource = root.node;
            }
          }
        }
      }
    }
    
    Item {
      Layout.fillWidth: true
      implicitHeight: 17 * Dat.Globals.notchScale
      
      Slider {
        id: slider
        anchors.fill: parent
        bottomInset: 0
        from: 0
        leftInset: 0
        padding: 0
        rightInset: 0
        snapMode: Slider.NoSnap
        to: 1
        topInset: 0
        value: root.node?.audio?.volume ?? 1
        
        background: ClippingRectangle {
          id: bgRect
          anchors.bottomMargin: 1 * Dat.Globals.notchScale
          anchors.fill: parent
          anchors.topMargin: 1 * Dat.Globals.notchScale
          antialiasing: true
          color: root.bgColor
          layer.smooth: true
          radius: 5 * Dat.Globals.notchScale
          
          Rectangle {
            id: progRect
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            antialiasing: true
            color: root.fgColor
            layer.smooth: true
            visible: true
            width: slider.visualPosition * parent.width
          }
        }
        
        handle: Rectangle {
          color: Dat.Colors.surface_container_high
          implicitHeight: 25 * Dat.Globals.notchScale
          implicitWidth: 13 * Dat.Globals.notchScale
          x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width + 1)
          y: slider.topPadding + slider.availableHeight / 2 - height / 2
          
          Rectangle {
            anchors.centerIn: parent
            color: root.fgColor
            height: parent.height
            radius: 10 * Dat.Globals.notchScale
            width: 5 * Dat.Globals.notchScale
          }
        }
        
        onMoved: {
          if (root.node) {
            root.node.audio.volume = slider.value;
          }
        }
      }
    }
  }
}
