import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../Data/" as Dat

Variants {
  model: Quickshell.screens

  delegate: WlrLayershell {
    id: clockWindow

    required property ShellScreen modelData
    layer: WlrLayer.Bottom
    anchors.left: true
    anchors.top: true
    visible: true

    implicitHeight: (screen.height * 0.38) * Dat.Globals.notchScale
    implicitWidth: (screen.width * 0.42) * Dat.Globals.notchScale

    color: "transparent"
    focusable: false

    Timer {
      id: clockTimer
      interval: 1000 // Update every second
      running: true
      repeat: true

      onTriggered: {
        updateTime()
      }
    }

    // Properties for time values
    property string currentTime: ""
    property string currentDay: ""
    property string currentDate: ""

    function updateTime() {
      let now = new Date()

      currentTime = Qt.formatTime(now, "hh:mm")

      currentDay = Qt.formatDate(now, "dddd")

      currentDate = Qt.formatDate(now, "dd MMM, yyyy")
    }

    Component.onCompleted: {
      updateTime()
    }

    Rectangle{
      anchors.fill: parent
      anchors.margins: 60 * Dat.Globals.notchScale
      anchors.topMargin: 70 * Dat.Globals.notchScale
      color: "transparent"

      // Main clock container
      ColumnLayout {
        anchors.fill: parent
        spacing: 2

        // Time display
        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: childrenRect.height
          color: "transparent"

          Text {
            id: timeLabel
            anchors.left: parent.left
            text: clockWindow.currentTime
            font.family: "FiraCode Nerd Font, monospace"
            font.pixelSize: 96 * Dat.Globals.notchScale
            font.weight: Font.Bold
            color: Dat.Colors.primary

            // Fade-in animation
            NumberAnimation on opacity {
              from: 0
              to: 1
              duration: 1000
              easing.type: Easing.OutQuad
              running: true
            }
          }
        }
        
        // Day and date row
        RowLayout {
          Layout.fillWidth: true
          Layout.preferredHeight: childrenRect.height
          spacing: 0
          
          Text {
            id: dayLabel
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 10
            text: clockWindow.currentDay
            font.family: "FiraCode Nerd Font, monospace"
            font.pixelSize: 32 * Dat.Globals.notchScale
            font.weight: Font.Bold
            color: Dat.Colors.secondary

            NumberAnimation on opacity {
              from: 0
              to: 1
              duration: 1000
              easing.type: Easing.OutQuad
              running: true
            }
          }

          Item {
              Layout.fillWidth: true // Spacer
          }

          Text {
            id: dateLabel
            Layout.alignment: Qt.AlignRight
            text: clockWindow.currentDate
            font.family: "FiraCode Nerd Font, monospace"
            font.pixelSize: 32 * Dat.Globals.notchScale
            font.weight: Font.Bold
            color: Dat.Colors.secondary 

            NumberAnimation on opacity {
              from: 0
              to: 1
              duration: 1000
              easing.type: Easing.OutQuad
              running: true
            }
          }
        }
      }
    }
  }
}
