pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../Data/" as Dat
Rectangle {
  property int index: SwipeView.index
  color: "transparent"
  
  Rectangle {
    color: "transparent"
    radius: 20 * Dat.Globals.notchScale
    anchors.fill: parent
    anchors.margins: 8 * Dat.Globals.notchScale

    Rectangle{
      anchors.fill: parent
      radius: 20 * Dat.Globals.notchScale
      color: Dat.Colors.surface_container
    }

    RowLayout {
      anchors.fill: parent
      anchors.margins: 10 * Dat.Globals.notchScale
      anchors.rightMargin: 5 * Dat.Globals.notchScale

      ColumnLayout {
        // Month display
        Layout.fillHeight: true
        Layout.leftMargin: 12 * Dat.Globals.notchScale
        Layout.minimumWidth: 30 * Dat.Globals.notchScale
        spacing: 0

        Rectangle {
          Layout.fillWidth: true
          bottomLeftRadius: 0
          bottomRightRadius: 0
          color: Dat.Colors.primary_container
          // Day display
          implicitHeight: 18 * Dat.Globals.notchScale
          radius: 20 * Dat.Globals.notchScale
          Text {
            id: weekDayText
            anchors.centerIn: parent
            color: Dat.Colors.on_primary_container
            font.pointSize: 8 * Dat.Globals.notchScale
            text: Qt.formatDateTime(Dat.Clock?.date, "ddd")
          }
        }
        Rectangle {
          Layout.fillHeight: true
          Layout.fillWidth: true
          color: Dat.Colors.primary
          radius: 10 * Dat.Globals.notchScale
          topLeftRadius: 0
          topRightRadius: 0
          Text {
            anchors.centerIn: parent
            color: Dat.Colors.on_primary
            font.pointSize: 12 * Dat.Globals.notchScale
            rotation: -90
            text: Qt.formatDateTime(Dat.Clock?.date, "MMMM")
          }
        }
      }
      MonthGrid {
        id: monthGrid
        property int currDay: parseInt(Qt.formatDateTime(Dat.Clock?.date, "d"))
        property int currMonth: parseInt(Qt.formatDateTime(Dat.Clock?.date, "M")) - 1
        Layout.fillHeight: true
        Layout.fillWidth: true
        spacing: 2
        Layout.leftMargin: 20 * Dat.Globals.notchScale
        Layout.rightMargin: this.Layout.leftMargin
        // color: Dat.Colors.surface_container
        // color: "transparent"
        delegate: Rectangle {
          required property var model
          // Add explicit dimensions that scale
          width: 30 * Dat.Globals.notchScale
          height: 30 * Dat.Globals.notchScale
          color: (monthGrid.currDay == model.day && monthGrid.currMonth == model.month) ? Dat.Colors.primary : "transparent"
          radius: 10 * Dat.Globals.notchScale
          Text {
            anchors.centerIn: parent
            // Add scaled font size
            font.pointSize: 10 * Dat.Globals.notchScale
            color: (parent.model.month == monthGrid.currMonth) ? (parent.model.day == monthGrid.currDay) ? Dat.Colors.on_primary : Dat.Colors.on_surface : Dat.Colors.withAlpha(Dat.Colors.on_surface_variant, 0.70)
            horizontalAlignment: Text.AlignVCenter
            text: parent.model.day
            verticalAlignment: Text.AlignVCenter
          }
        }
      }
    }
  }
}
