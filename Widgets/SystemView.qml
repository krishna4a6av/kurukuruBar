pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls

import "../Data/" as Dat
import "../Generics/" as Gen
import "../Widgets/" as Wid

Rectangle {
  id: root

  property int index: SwipeView.index
  property bool isCurrent: SwipeView.isCurrentItem

  color: "transparent"

  RowLayout {
    anchors.fill: parent
    anchors.margins: 10 * Dat.Globals.notchScale
    anchors.rightMargin: 5 * Dat.Globals.notchScale
    spacing: 5 * Dat.Globals.notchScale

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      clip: true
      color: Dat.Colors.surface_container_high
      radius: 10 * Dat.Globals.notchScale

      Image {
        id: smLogo

        fillMode: Image.PreserveAspectCrop
        height: this.width
        layer.enabled: true
        opacity: 1
        rotation: 0
        source: "../Assets/Arch.png"  //change the logo image here. You can chose from the one i put in assets folder, I kept a few!
        width: parent.height
        x: -(this.width / 2.5)

        layer.effect: MultiEffect {
          colorization: 1
          colorizationColor: Dat.Colors.secondary
        }
        Behavior on rotation {
          NumberAnimation {
            duration: 500
            easing.type: Easing.Linear
          }
        }

        Timer {
          interval: 500
          repeat: true
          running: Dat.Globals.notchState == "FULLY_EXPANDED" && root.isCurrent
          triggeredOnStart: true

          //onTriggered: parent.rotation = (parent.rotation + 3) % 360 //Uncomment for rotation Arch do not look good on rotation so turned off
        }
      }

      ColumnLayout { // area to the right of the image
        id: rightArea

        anchors.bottom: parent.bottom
        anchors.left: smLogo.right
        // radius: 10
        anchors.margins: 12 * Dat.Globals.notchScale
        anchors.right: parent.right
        anchors.rightMargin: 13 * Dat.Globals.notchScale
        anchors.top: parent.top

        Rectangle {
          id: monitorRect

          clip: true
          color: Dat.Colors.surface_container
          radius: 10 * Dat.Globals.notchScale
          implicitWidth: 150 * Dat.Globals.notchScale
          implicitHeight: 100 * Dat.Globals.notchScale

          RowLayout {
            anchors.fill: parent
            anchors.margins: 10 * Dat.Globals.notchScale

            Item {
              Layout.bottomMargin: this.Layout.topMargin
              Layout.fillHeight: true
              Layout.fillWidth: true
              Layout.topMargin: 20 * Dat.Globals.notchScale

              Text {
                id: hyprIcon

                anchors.fill: parent
                color: Dat.Colors.primary
                font.pointSize: 28 * Dat.Globals.notchScale
                horizontalAlignment: Text.AlignHCenter
                text: ""
                verticalAlignment: Text.AlignVCenter
              }
            }

            Item {
              Layout.fillWidth: true
              implicitHeight: this.width

              GridLayout {
                anchors.fill: parent
                columns: 3
                rows: 3

                Repeater {
                  model: 9

                  Rectangle {
                    required property int index

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: (Hyprland.focusedWorkspace?.id == this.index + 1) ? Dat.Colors.primary : Dat.Colors.surface_container_high
                    radius: this.width

                    Gen.MouseArea {
                      layerColor: Dat.Colors.primary

                      onClicked: Hyprland.dispatch("workspace " + (parent.index + 1))
                    }
                  }
                }
              }
            }
          }
        }

        Rectangle {
          // no longer system tray, its gonna be the base of a monitor
          Layout.alignment: Qt.AlignCenter
          antialiasing: true
          // color: "transparent"
          color: Dat.Colors.outline
          implicitHeight: 10 * Dat.Globals.notchScale
          implicitWidth: 80 * Dat.Globals.notchScale
          radius: 10 * Dat.Globals.notchScale
        }
      }
    }

    Item {
      Layout.fillHeight: true
      implicitWidth: 30 * Dat.Globals.notchScale

      ColumnLayout {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width

        Wid.SessionDots {
        }
      }
    }
  }
}
