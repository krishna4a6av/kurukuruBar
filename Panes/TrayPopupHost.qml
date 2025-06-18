import QtQuick
import QtQuick.Controls

Item {
  id: popupHost
  width: 0
  height: 0

  // Public references for injection
  property alias trayPopup: trayPopup
  property alias menuStack: menuStackView

  Popup {
    id: trayPopup
    modal: false
    focus: true
    visible: false
    width: 200
    height: 300
    z: 9999

    background: Rectangle {
      color: "#222"
      radius: 10
    }

    StackView {
      id: menuStackView
      anchors.fill: parent
      background: null
    }
  }
}

