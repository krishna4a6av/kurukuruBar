import QtQuick
import QtQuick.Controls
import Quickshell.Services.Mpris
import Quickshell

import "../Data/" as Dat
import "../Widgets/" as Wid

Rectangle {
  color: "transparent"

  AnimatedImage {
    anchors.fill: parent
    fillMode: Image.PreserveAspectFit
    playing: Mpris.players.values.length == 0
    source: "../Assets/herta/triplehertaroll.gif"
  }

  Text {
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 5 * Dat.Globals.notchScale
    anchors.horizontalCenter: parent.horizontalCenter
    font.pixelSize: 22 * Dat.Globals.notchScale
    color: Dat.Colors.on_surface
    text: "Play some music"
  }

  SwipeView {
    id: list

    anchors.fill: parent
    orientation: Qt.Vertical

    Repeater {
      model: ScriptModel {
        values: [...Mpris.players.values]
      }

      Wid.MprisItem {
        id: rect

        property int increaseOrDecrease: 0
        required property int index
        required property MprisPlayer modelData
        property bool readyToShow: false

        player: modelData
      }
    }
  }

  PageIndicator {
    id: pageIndicator

    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    count: list.count
    currentIndex: list.currentIndex
    interactive: false
    rotation: 90
    visible: this.count > 1

    delegate: Rectangle {
      id: smallrect

      required property int index

      color: (index == list.currentIndex) ? "white" : Dat.Colors.withAlpha("white", 0.5)
      height: this.width
      radius: 6 * Dat.Globals.notchScale
      width: 6 * Dat.Globals.notchSCale

      Behavior on color {
        ColorAnimation {
          duration: 500
        }
      }
    }
  }
}
