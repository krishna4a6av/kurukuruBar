pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../Generics/" as Gen
import "../Data/" as Dat
import "../Widgets/" as Wid

Rectangle {
  id: root

  color: "transparent"

  RowLayout {
    anchors.fill: parent
    layoutDirection: Qt.RightToLeft
    spacing: 8 * Dat.Globals.notchScale

    Rectangle {
      id: swipeRect

      Layout.fillHeight: true
      Layout.fillWidth: true
      // Pages
      clip: true
      color: Dat.Colors.surface_container_low
      radius: root.radius

      SwipeView {
        id: swipeArea

        anchors.fill: parent
        orientation: Qt.Horizontal

        Component.onCompleted: () => {
          Dat.Globals.swipeIndexChanged.connect(() => {
            if (swipeArea.currentIndex != Dat.Globals.swipeIndex) {
              swipeArea.currentIndex = Dat.Globals.swipeIndex;
            }
          });

          // FOR DEBUGGING
          // swipeArea.currentIndex = 3;
          // Dat.Globals.notchState = "FULLY_EXPANDED";
        }
        onCurrentIndexChanged: () => {
          if (swipeArea.currentIndex != Dat.Globals.swipeIndex) {
            Dat.Globals.swipeIndex = swipeArea.currentIndex;
          }
        }

        Wid.HomeView {
          height: swipeRect.height
          radius: swipeRect.radius
          width: swipeRect.width
        }

        Wid.CalendarView {
          height: swipeRect.height
          radius: swipeRect.radius
          width: swipeRect.width
        }

        Wid.SystemView {
          height: swipeRect.height
          radius: swipeRect.radius
          width: swipeRect.width
        }

        Wid.MusicView {
          height: swipeRect.height
          radius: swipeRect.radius
          width: swipeRect.width
        }

        Wid.SettingsView {
          height: swipeRect.height
          radius: swipeRect.radius
          width: swipeRect.width
        }
      }
    }

    Rectangle {
      // the page indicator
      Layout.leftMargin: 8 * Dat.Globals.notchScale
      color: Dat.Colors.surface_container_low
      implicitHeight: 160 * Dat.Globals.notchScale
      implicitWidth: 38 * Dat.Globals.notchScale
      radius: 20 * Dat.Globals.notchScale

      ColumnLayout {
        id: tabCols

        anchors.verticalCenter: parent.verticalCenter
        spacing: 10 * Dat.Globals.notchScale
        width: parent.width

        Repeater {
          model: ["󰋜", "󰃭", "󰣇", "󰎇", "󰒓"]//󱄅,

          Rectangle {
            id: tabDot

            required property int index
            required property string modelData

            Layout.alignment: Qt.AlignCenter
            color: "transparent"
            implicitHeight: this.implicitWidth
            implicitWidth: 20 * Dat.Globals.notchScale
            radius: 20 * Dat.Globals.notchScale

            Text {
              id: dotText

              anchors.centerIn: parent
              color: Dat.Colors.on_surface
              font.pointSize: 11 * Dat.Globals.notchScale
              state: (swipeArea.currentIndex == tabDot.index) ? "ACTIVE" : "INACTIVE"
              text: tabDot.modelData

              states: [
                State {
                  name: "ACTIVE"

                  PropertyChanges {
                    dotText.scale: 1.6
                  }
                },
                State {
                  name: "INACTIVE"

                  PropertyChanges {
                    dotText.scale: 1
                  }
                }
              ]
              transitions: [
                Transition {
                  from: "INACTIVE"
                  to: "ACTIVE"

                  NumberAnimation {
                    duration: Dat.MaterialEasing.standardAccelTime
                    easing.bezierCurve: Dat.MaterialEasing.standardAccel
                    property: "scale"
                  }
                },
                Transition {
                  from: "ACTIVE"
                  to: "INACTIVE"

                  NumberAnimation {
                    duration: Dat.MaterialEasing.standardDecelTime
                    easing.bezierCurve: Dat.MaterialEasing.standardDecel
                    property: "scale"
                  }
                }
              ]
            }

            Gen.MouseArea {
              layerRect.scale: dotText.scale

              onClicked: swipeArea.setCurrentIndex(tabDot.index)
            }
          }
        }
      }
    }
  }
}
