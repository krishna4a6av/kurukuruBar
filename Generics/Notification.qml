import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Hyprland

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: root

  required property Notification notif

  color: "transparent"
  height: bodyNActionCol.height

  Behavior on x {
    SmoothedAnimation {
    }
  }

  onXChanged: {
    root.opacity = 1 - (Math.abs(root.x) / width);
  }

  MouseArea {
    id: dragArea

    acceptedButtons: Qt.MiddleButton | Qt.LeftButton
    anchors.fill: parent

    onClicked: mevent => {
      if (mevent.button == Qt.MiddleButton) {
        root.notif.dismiss();
      }
    }

    drag {
      axis: Drag.XAxis
      target: parent

      onActiveChanged: {
        if (dragArea.drag.active) {
          return;
        }
        if (Math.abs(root.x) > (root.width * 0.45)) {
          root.notif.dismiss();
        } else {
          root.x = 0;
        }
      }
    }
  }

  // Close button
  Rectangle {
    id: closeButton
    
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: 8 * Dat.Globals.notchScale
    width: 24 * Dat.Globals.notchScale
    height: 24 * Dat.Globals.notchScale
    radius: 12 * Dat.Globals.notchScale
    color: Dat.Colors.primary_container
    opacity: closeButtonArea.containsMouse ? 1.0 : 0.7
    z: 10
    
    Behavior on opacity {
      NumberAnimation { duration: 150 }
    }
    
    Text {
      anchors.centerIn: parent
      text: "×"
      color: Dat.Colors.on_secondary
      font.pixelSize: 16 * Dat.Globals.notchScale
      font.bold: true
    }
    
    MouseArea {
      id: closeButtonArea
      
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      
      onClicked: {
        root.notif.dismiss();
      }
    }
  }

  RowLayout {
    id: bodyNActionCol

    anchors.left: parent.left
    anchors.margins: 10 * Dat.Globals.notchScale
    anchors.right: parent.right
    anchors.rightMargin: 40 * Dat.Globals.notchScale // Extra margin to avoid overlapping with close button
    anchors.top: parent.top
    spacing: 10 * Dat.Globals.notchScale

    Item {
      Layout.alignment: Qt.AlignTop
      implicitHeight: 60 * Dat.Globals.notchScale
      implicitWidth: this.implicitHeight
      visible: root.notif?.image ?? false

      Image {
        id: notifIcon

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        mipmap: true
        source: root.notif?.image ?? ""
        visible: false
      }

      MultiEffect {
        anchors.fill: notifIcon
        antialiasing: true
        maskEnabled: true
        maskSource: notifIconMask
        maskSpreadAtMin: 1.0
        maskThresholdMax: 1.0
        maskThresholdMin: 0.5
        source: notifIcon
      }

      Item {
        id: notifIconMask

        height: this.width
        layer.enabled: true
        visible: false
        width: notifIcon.width

        Rectangle {
          height: this.width
          radius: 10 * Dat.Globals.notchScale
          width: notifIcon.width
        }
      }
    }

    ColumnLayout {
      Layout.fillHeight: true
      Layout.fillWidth: true

      Rectangle {
        Layout.fillWidth: true
        color: "transparent"
        implicitHeight: sumText.contentHeight + bodText.contentHeight
        topLeftRadius: 20 * Dat.Globals.notchScale
        topRightRadius: 20 * Dat.Globals.notchScale

        RowLayout {
          id: infoRow

          anchors.top: parent.top
          height: sumText.contentHeight
          width: parent.width

          Text {
            id: sumText

            Layout.maximumWidth: ((root.width - notifIcon.width) * 0.65) // Reduced to make room for close button
            color: Dat.Colors.primary
            elide: Text.ElideRight
            font.pixelSize: 14 * Dat.Globals.notchScale
            text: root.notif?.summary ?? "Kokomi"
          }

          Rectangle {
            Layout.alignment: Qt.AlignRight
            color: "transparent"
            implicitHeight: appText.contentHeight + 2 * Dat.Globals.notchScale
            implicitWidth: appText.contentWidth + 10 * Dat.Globals.notchScale
            radius: 20 * Dat.Globals.notchScale

            Text {
              id: appText

              anchors.centerIn: parent
              color: Dat.Colors.tertiary
              font.bold: true
              font.pointSize: 8 * Dat.Globals.notchScale
              text: root.notif?.appName ?? "idk"
            }
          }
        }

        Text {
          id: bodText

          anchors.top: infoRow.bottom
          color: Dat.Colors.on_surface
          font.pointSize: 11 * Dat.Globals.notchScale
          text: root.notif?.body ?? "very cool body that is missing"
          textFormat: Text.MarkdownText
          width: parent.width
          wrapMode: Text.WrapAtWordBoundaryOrAnywhere

          MouseArea {
            id: bodMArea

            acceptedButtons: Qt.LeftButton
            anchors.fill: parent

            // thanks end_4 for this <3
            onClicked: {
              const hovLink = bodText.hoveredLink;
              if (hovLink == "") {
                return;
              }
              Hyprland.dispatch("exec xdg-open " + hovLink);
            }
          }
        }
      }

      Flickable {
        id: flick

        Layout.alignment: Qt.AlignRight
        Layout.bottomMargin: 20 * Dat.Globals.notchScale
        Layout.leftMargin: this.Layout.rightMargin
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        contentWidth: actionRow.width
        implicitHeight: 23 * Dat.Globals.notchScale
        // thanks to Aureus :>
        implicitWidth: Math.min(bodyNActionCol.width - 20 * Dat.Globals.notchScale, actionRow.width)

        RowLayout {
          id: actionRow

          anchors.right: parent.right
          height: parent.height

          Repeater {
            model: root.notif?.actions

            Rectangle {
              required property NotificationAction modelData

              Layout.fillHeight: true
              color: Dat.Colors.secondary
              implicitWidth: actionText.contentWidth + 14 * Dat.Globals.notchScale
              radius: 20 * Dat.Globals.notchScale

              Text {
                id: actionText

                anchors.centerIn: parent
                color: Dat.Colors.on_secondary
                font.pointSize: 11 * Dat.Globals.notchScale
                text: parent.modelData?.text ?? "activate"
              }

              Gen.MouseArea {
                layerColor: actionText.color

                onClicked: parent.modelData.invoke()
              }
            }
          }
        }
      }
    }
  }
}
