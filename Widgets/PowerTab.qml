pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.UPower

import "../Data/" as Dat
import "../Generics/" as Gen
import "../Widgets/" as Wid

Rectangle {
  color: Dat.Colors.surface_container_high
  radius: 20 * Dat.Globals.notchScale

  RowLayout {
    anchors.fill: parent
    spacing: 0

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      color: "transparent"
      radius: 20 * Dat.Globals.notchScale

      Rectangle {
        anchors.fill: infoCol
        color: Dat.Colors.surface_container
        radius: 10 * Dat.Globals.notchScale
      }

      ColumnLayout {
        id: infoCol

        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        Item {
          Layout.fillHeight: true
          Layout.fillWidth: true
          clip: true

          RowLayout {
            anchors.fill: parent
            anchors.margins: 3 * Dat.Globals.notchScale
            spacing: 0

            Repeater {
              id: resourceRepeater

              readonly property real cpuUsage: (1 - (Dat.Resources.cpu.idleSec / Dat.Resources.cpu.totalSec))
              readonly property real memUsage: (1 - (Dat.Resources.mem.free / Dat.Resources.mem.total))

              model: [
                {
                  icon: "",
                  label: "Cpu"
                },
                {
                  icon: "",
                  label: "Mem"
                }
              ]

              delegate: Item {
                id: itemRoot

                required property int index
                required property var modelData
                property real usage: (index) ? resourceRepeater.memUsage : resourceRepeater.cpuUsage

                Layout.alignment: Qt.AlignCenter
                Layout.fillHeight: true
                implicitWidth: this.height

                Gen.CircularProgress {
                  anchors.centerIn: parent
                  degreeLimit: 290
                  lineWidth: 7 * Dat.Globals.notchScale
                  rotation: -189
                  size: parent.width
                  value: itemRoot.usage
                }

                Text {
                  anchors.centerIn: parent
                  color: Dat.Colors.primary
                  font.pointSize: 24 * Dat.Globals.notchScale
                  text: (parent.usage * 100).toFixed(0)
                }

                Rectangle {
                  anchors.bottom: parent.bottom
                  anchors.bottomMargin: this.anchors.rightMargin
                  anchors.right: parent.right
                  anchors.rightMargin: 5 * Dat.Globals.notchScale
                  color: Dat.Colors.primary
                  height: this.width
                  radius: this.width
                  width: 35 * Dat.Globals.notchScale

                  Text {
                    anchors.centerIn: parent
                    color: Dat.Colors.on_primary
                    font.pointSize: 16 * Dat.Globals.notchScale
                    text: itemRoot.modelData.icon
                  }
                }
              }
            }
          }
        }

        Rectangle {
          // BATTERY information
          Layout.fillWidth: true
          color: Dat.Colors.surface_container_highest
          implicitHeight: 28 * Dat.Globals.notchScale
          radius: 20 * Dat.Globals.notchScale
          topLeftRadius: 0
          topRightRadius: 0
          visible: UPower.displayDevice.percentage > 0

          Wid.PowerInfo {
            anchors.fill: parent
            anchors.leftMargin: 10 * Dat.Globals.notchScale
            anchors.rightMargin: 10 * Dat.Globals.notchScale
          }
        }
      }
    }

    Rectangle {
      id: powerSliderRect

      Layout.margins: 3 * Dat.Globals.notchScale
      color: "transparent"
      implicitHeight: parent.height - (14 * Dat.Globals.notchScale)
      implicitWidth: 40 * Dat.Globals.notchScale
      radius: 40 * Dat.Globals.notchScale

      // I should write my own generic slider
      Slider {
        id: slider

        anchors.fill: parent
        from: 0
        orientation: Qt.Vertical
        snapMode: Slider.SnapAlways
        stepSize: 1
        to: 2
        value: PowerProfiles.profile

        background: ColumnLayout {
          anchors.fill: parent
          spacing: 0

          Repeater {
            model: ["", "", ""]

            Item {
              required property int index
              required property string modelData

              Layout.alignment: Qt.AlignHCenter
              implicitHeight: this.implicitWidth
              implicitWidth: slider.width

              Text {
                anchors.centerIn: parent
                color: Dat.Colors.on_surface
                font.pointSize: 12 * Dat.Globals.notchScale
                text: parent.modelData
              }
            }
          }
        }
        handle: Rectangle {
          anchors.horizontalCenter: parent.horizontalCenter
          color: Dat.Colors.primary
          height: this.width
          radius: this.width
          visible: true
          width: slider.width
          y: slider.visualPosition * (slider.availableHeight - height)

          Behavior on y {
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedTime
              easing.bezierCurve: Dat.MaterialEasing.emphasized
            }
          }

          Text {
            anchors.centerIn: parent
            color: Dat.Colors.on_primary
            font.pointSize: 12 * Dat.Globals.notchScale
            text: switch (PowerProfiles.profile) {
            case 0:
              "";
              break;
            case 1:
              "";
              break;
            case 2:
              "";
              break;
            }
          }
        }

        onMoved: {
          PowerProfiles.profile = slider.value;
        }
      }
    }
  }
}
