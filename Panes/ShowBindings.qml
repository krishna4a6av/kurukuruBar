import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Data" as Dat

Popup {
  id: popupRoot
  modal: true
  focus: true
  closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

  width: 400 * Dat.Globals.notchScale
  height: (keybindings.length * 30 + 40) * Dat.Globals.notchScale
  anchors.centerIn: Overlay.overlay  // Center the popup

  property var keybindings: []

  // Convert Qt.Key_* to readable string
  function keyToString(code) {
    switch (code) {
      case Qt.Key_Space: return "Space";
      case Qt.Key_Escape: return "Escape";
      case Qt.Key_C: return "C";
      case Qt.Key_D: return "D";
      case Qt.Key_N: return "N";
      case Qt.Key_T: return "T";
      case Qt.Key_Left: return "Left Arrow";
      case Qt.Key_Right: return "Right Arrow";
      case Qt.Key_Up: return "Up Arrow";
      case Qt.Key_Down: return "Down Arrow";
      case Qt.Key_Slash: return "/";
      default: return "Key(" + code + ")";
    }
  }

  // Close when losing focus
  onActiveFocusChanged: if (!activeFocus) close()

  background: Rectangle {
    color:  Dat.Colors.primary_fixed
    radius: 12 * Dat.Globals.notchScale

  }


  Rectangle {
    anchors.fill: parent
    radius: 10 * Dat.Globals.notchScale
    color: Dat.Colors.surface_container
    border.width: 0

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 15 * Dat.Globals.notchScale
      spacing: 10 * Dat.Globals.notchScale

      Text {
        text: "All Keybindings"
        font.pixelSize: 16 * Dat.Globals.notchScale
        font.bold: true
        color: Dat.Colors.on_surface
        Layout.alignment: Qt.AlignHCenter
      }
      Rectangle {
        height: 1
        width: parent.width
        color: Dat.Colors.outline_variant
        Layout.fillWidth: true
      }

      Repeater {
        model: keybindings

        RowLayout {
          spacing: 10 * Dat.Globals.notchScale
          Layout.leftMargin: 20 * Dat.Globals.notchScale

        Text {
          text: {
            let prefix = "";
            if (modelData.alt) prefix += "Alt + ";
            if (modelData.shift) prefix += "Shift + ";
            prefix + keyToString(modelData.key);
          }
          font.pixelSize: 13 * Dat.Globals.notchScale
          color: Dat.Colors.primary
        }


          Text {
            text: "→"
            font.pixelSize: 13 * Dat.Globals.notchScale
            color: Dat.Colors.on_surface
          }

          Text {
            text: modelData.label
            font.pixelSize: 13 * Dat.Globals.notchScale
            color: Dat.Colors.on_surface
          }
        }
      }
    }
  }
}

