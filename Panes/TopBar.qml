import QtQuick
import QtQuick.Layouts
import "../Data/" as Dat
import "../Widgets/" as Wid
RowLayout {
  // Left
  Rectangle {
    Layout.fillHeight: true
    Layout.fillWidth: true
    clip: true
    color: "transparent"
    RowLayout {
      anchors.left: parent.left
      anchors.leftMargin: 8 * Dat.Globals.notchScale
      anchors.verticalCenter: parent.verticalCenter
      spacing: 6 * Dat.Globals.notchScale

      Wid.WorkspacePill {
      }

      Wid.AudioSwiper {
        implicitHeight: 20 * Dat.Globals.notchScale
        radius: 20 * Dat.Globals.notchScale
      }

      Wid.MprisDot {
        implicitHeight: 20 * Dat.Globals.notchScale
        implicitWidth: 20 * Dat.Globals.notchScale
        radius: 20 * Dat.Globals.notchScale
      }

      Wid.RecordingDot {
        implicitHeight: 20 * Dat.Globals.notchScale
        implicitWidth: 20 * Dat.Globals.notchScale
        radius: 20 * Dat.Globals.notchScale
      }
    }
  }
  // Center
  Rectangle {
    Layout.fillHeight: true
    Layout.fillWidth: true
    color: "transparent"
    
    Wid.TimePill {
    }
  }
  // Right
  Rectangle {
    Layout.fillHeight: true
    Layout.fillWidth: true
    color: "transparent"

    RowLayout {
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      layoutDirection: Qt.RightToLeft
      spacing: 8 * Dat.Globals.notchScale
      
      ColumnLayout{
        Layout.fillHeight: true 
        spacing: 0

        Text {
          Layout.alignment: Qt.AlignTop
          color: Dat.Colors.primary
          font.pointSize: 11 * Dat.Globals.notchScale
          text: "-"

          MouseArea {
            anchors.fill: parent
            onClicked: mevent => {
              if (Dat.Globals.notchState !== "COLLAPSED") {
                Dat.Globals.notchState = "COLLAPSED";
                return;
              }
            }
          }
        }
        Text {
          // little arrow to toggle notch expand states
          Layout.rightMargin: 8 * Dat.Globals.notchScale
          color: Dat.Colors.primary
          font.pointSize: 10 * Dat.Globals.notchScale
          text: (Dat.Globals.notchState == "FULLY_EXPANDED") ? "" : ""
          verticalAlignment: Text.AlignVCenter

          MouseArea {
            anchors.fill: parent
            onClicked: mevent => {
              if (Dat.Globals.notchState == "EXPANDED") {
                Dat.Globals.notchState = "FULLY_EXPANDED";
                return;
              }
              Dat.Globals.notchState = "EXPANDED";
            }
          }
        }
      }
      
      Wid.TrayPill{
        implicitHeight: 20 * Dat.Globals.notchScale
        radius: 20 * Dat.Globals.notchScale
      }

      Wid.BatteryPill {
        implicitHeight: 20 * Dat.Globals.notchScale
        radius: 20 * Dat.Globals.notchScale
      }
     
      Wid.BrightnessDot {
        implicitHeight: 20 * Dat.Globals.notchScale
        implicitWidth: 20 * Dat.Globals.notchScale
        radius: 20 * Dat.Globals.notchScale
      }
    }
  }
}
