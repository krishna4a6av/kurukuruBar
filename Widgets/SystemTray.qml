pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "../Generics/" as Gen
import "../Data/" as Dat
import "../Widgets/" as Wid

Rectangle {
  id: systemTray

  property alias trayRepeater: trayRepeater
  property var menuStack: menuStackView
  property int currentTrayIndex: -1  // Track the currently open tray item index

  color: "transparent"
  implicitWidth: (trayLayout.implicitWidth + 18) * Dat.Globals.notchScale
  implicitHeight: 22 * Dat.Globals.notchScale

  Rectangle{
    anchors.fill: parent
    color: Dat.Colors.primary
    radius: 12 * Dat.Globals.notchScale

  }

  RowLayout {
    id: trayLayout
    anchors.fill: parent
    spacing: 4 * Dat.Globals.notchScale
    // System tray items

    Repeater {
      id: trayRepeater
      model: SystemTray.items

      delegate: Rectangle {
        id: trayItemRoot
        required property int index
        required property SystemTrayItem modelData
                
        property var menu: Wid.TrayItemMenu {
          height: menuStackView.height
          trayMenu: trayMenu
          width: menuStackView.width
        }
                
        color: "transparent"
        implicitHeight: trayItemIcon.width
        implicitWidth: implicitHeight
        Layout.preferredWidth: implicitWidth
        Layout.preferredHeight: implicitHeight
                
        Image {
          id: trayItemIcon
          anchors.top: parent.top
          antialiasing: true
          height: width
          mipmap: true
          smooth: true
          source: {
            const icon = trayItemRoot.modelData.icon;
            if (icon.includes("?path=")) {
              const [name, path] = icon.split("?path=");
                return `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
              }
              return trayItemRoot.modelData.icon;
            }
            width: 22 * Dat.Globals.notchScale
                    
            MouseArea {
              acceptedButtons: Qt.LeftButton | Qt.RightButton
              anchors.fill: parent
                        
              onClicked: mevent => {
                if (mevent.button === Qt.RightButton) {
                    trayItemRoot.modelData.activate();
                    return;
                }

                if (!trayItemRoot.modelData.hasMenu)
                    return;

                const globalPos = trayItemRoot.mapToItem(systemTray, 0, trayItemRoot.height);
                trayPopup.x = globalPos.x - (140 * Dat.Globals.notchScale);
                trayPopup.y = globalPos.y + (5 * Dat.Globals.notchScale);

                const newMenu = trayItemRoot.menu;

                // Popup on-off on click on icons
                if (systemTray.currentTrayIndex == trayItemRoot.index) {
                  trayPopup.close();
                  systemTray.currentTrayIndex = -1;
                } else {
                  // Replace the current menu or push if stack is empty
                  if (menuStackView.depth > 0) {
                    menuStackView.replace(newMenu);
                  } else {
                    menuStackView.push(newMenu);
                  }
                  trayPopup.open();
                  systemTray.currentTrayIndex = trayItemRoot.index;
                }
              }

            }
          }
          QsMenuOpener {
            id: trayMenu
            menu: trayItemRoot.modelData.menu
          }
        }
      }
    }
    
    // Pop Menu for the TrayItems on top 
  Popup {
    id: trayPopup
    modal: false
    focus: true
    visible: false

    clip: false

    width: 220 * Dat.Globals.notchScale
    height: 230 * Dat.Globals.notchScale

    x: (systemTray.width - width) / 2
    y: systemTray.height

    background: Rectangle {
      color: Dat.Colors.surface_container
      radius: 12 * Dat.Globals.notchScale

      Rectangle {
        anchors.margins: -2 * Dat.Globals.notchScale
        color: "transparent"
        border.width: 1 * Dat.Globals.notchScale
        radius: (parent.radius + 1) * Dat.Globals.notchScale
      }
    }

    StackView {
      id: menuStackView
      anchors.fill: parent
      background: null  // background already handled by Popup

      replaceEnter: Transition {
        NumberAnimation {
          property: "opacity"
          from: 0
          to: 1
          duration: 100
          easing.type: Easing.InOutQuad
        }
      }
      replaceExit: Transition {
        NumberAnimation {
          property: "opacity"
          from: 1
          to: 0
          duration: 100
          easing.type: Easing.InOutQuad
        }
      }
    }

    Component.onCompleted: {
      Dat.Globals.trayPopup = trayPopup;
    }

  }
}
