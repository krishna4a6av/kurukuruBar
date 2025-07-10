pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell

import "../Data/" as Dat

ColumnLayout {
  id: root
  Layout.fillWidth: true
  Layout.fillHeight: true

  // Spacer above the faceIcon
  Item {
    Layout.fillHeight: true
  }

  Rectangle {
    id: faceRect
    Layout.alignment: Qt.AlignHCenter
    color: "transparent"
    implicitHeight: faceIcon.width
    implicitWidth: faceIcon.width

    AnimatedImage {
      id: faceIcon
      anchors.centerIn: parent
      width: 90*Dat.Globals.notchScale
      height: width
      mipmap: true
      source: "../Assets/herta/Hattug.jpg" //add the new image to assets and change name to the image
      visible: false
    }

    MultiEffect {
      anchors.fill: faceIcon
      antialiasing: true
      maskEnabled: true
      maskSource: faceIconMask
      maskSpreadAtMin: 1.0
      maskThresholdMax: 1.0
      maskThresholdMin: 0.5
      source: faceIcon
    }

    Item {
      id: faceIconMask
      height: width
      width: faceIcon.width
      visible: false
      layer.enabled: true

      Rectangle {
        height: width
        width: faceIcon.width
        radius: 20*Dat.Globals.notchScale
      }
    }
  }

  Rectangle {
    id: informationRect
    Layout.fillWidth: true
    Layout.preferredHeight: 50 * Dat.Globals.notchScale
    color: Dat.Colors.surface_container
    radius: 20 * Dat.Globals.notchScale

    Text {
      anchors.centerIn: parent
      color: Dat.Colors.on_surface
      font.pointSize: 13*Dat.Globals.notchScale
      text: "Hello there!"
    }
  }
}

