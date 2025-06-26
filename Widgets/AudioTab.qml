import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

import "../Generics/" as Gen
import "../Data/" as Dat

Rectangle {
  clip: true
  color: Dat.Colors.surface_container_high
  radius: 20 * Dat.Globals.notchScale

  ListView {
    anchors.fill: parent
    anchors.margins: 16 * Dat.Globals.notchScale
    spacing: 12 * Dat.Globals.notchScale

    delegate: Gen.AudioSlider {
      required property PwNode modelData

      implicitWidth: parent?.width ?? 0
      node: modelData
    }
    model: ScriptModel {
      id: sModel

      values: Pipewire.nodes.values.filter(node => node.audio).sort()
    }
  }

  PwObjectTracker {
    objects: sModel.values
  }
}
