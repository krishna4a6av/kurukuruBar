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
  implicitWidth: (trayLayout.implicitWidth + (12 * Dat.Globals.notchScale)) * Dat.Globals.notchScale
  implicitHeight: 22 * Dat.Globals.notchScale

  Rectangle{
    anchors.fill: parent
    color: Dat.Colors.primary
    radius: 12 * Dat.Globals.notchScale
  }

  RowLayout {
    id: trayLayout
    anchors.fill: parent
    anchors.leftMargin: 6 * Dat.Globals.notchScale
    anchors.rightMargin: 6 * Dat.Globals.notchScale
    spacing: 6 * Dat.Globals.notchScale
    
    // System tray items
    Repeater {
      id: trayRepeater
      model: SystemTray.items

      delegate: Rectangle {
        id: trayItemRoot
        required property int index
        required property SystemTrayItem modelData
                
        property var menu: Wid.TrayItemMenu {
          height: menuStackView.height - (menuStackView.depth > 1 ? backButton.height : 0)
          trayMenu: trayMenu
          width: menuStackView.width
          
          // Connect navigation signals
          onNavigateToSubmenu: function(submenu) {
            menuStackView.push(submenu);
          }
          
          onNavigateBack: function() {
            if (menuStackView.depth > 1) {
              menuStackView.pop();
            }
          }
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
          width: 18 * Dat.Globals.notchScale
                    
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
                // Clear the stack and push the root menu
                menuStackView.clear();
                menuStackView.push(newMenu);
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

    ColumnLayout {
      anchors.fill: parent
      spacing: 0
      
      // Back button - only visible when in submenu
      Rectangle {
        id: backButton
        Layout.fillWidth: true
        Layout.preferredHeight: 32 * Dat.Globals.notchScale
        visible: menuStackView.depth > 1
        color: Dat.Colors.surface_container_high
        radius: 8 * Dat.Globals.notchScale
        
        RowLayout {
          anchors.fill: parent
          anchors.leftMargin: 8 * Dat.Globals.notchScale
          spacing: 8 * Dat.Globals.notchScale
          
          Text {
            text: "◀"
            color: Dat.Colors.on_surface
            font.pointSize: 10 * Dat.Globals.notchScale
            verticalAlignment: Text.AlignVCenter
          }
          
          Text {
            text: "Back"
            color: Dat.Colors.on_surface
            font.pointSize: 10 * Dat.Globals.notchScale
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
          }
        }
        
        MouseArea {
          anchors.fill: parent
          onClicked: {
            if (menuStackView.depth > 1) {
              menuStackView.pop();
            }
          }
          hoverEnabled: true
          onEntered: backButton.color = Dat.Colors.surface_container_highest
          onExited: backButton.color = Dat.Colors.surface_container_high
        }
      }

      StackView {
        id: menuStackView
        Layout.fillWidth: true
        Layout.fillHeight: true
        background: null  // background already handled by Popup

        pushEnter: Transition {
          PropertyAnimation {
            property: "x"
            from: menuStackView.width
            to: 0
            duration: 200
            easing.type: Easing.OutQuad
          }
          PropertyAnimation {
            property: "opacity"
            from: 0
            to: 1
            duration: 200
          }
        }
        
        pushExit: Transition {
          PropertyAnimation {
            property: "x"
            from: 0
            to: -menuStackView.width * 0.3
            duration: 200
            easing.type: Easing.OutQuad
          }
          PropertyAnimation {
            property: "opacity"
            from: 1
            to: 0
            duration: 200
          }
        }
        
        popEnter: Transition {
          PropertyAnimation {
            property: "x"
            from: -menuStackView.width * 0.3
            to: 0
            duration: 200
            easing.type: Easing.OutQuad
          }
          PropertyAnimation {
            property: "opacity"
            from: 0
            to: 1
            duration: 200
          }
        }
        
        popExit: Transition {
          PropertyAnimation {
            property: "x"
            from: 0
            to: menuStackView.width
            duration: 200
            easing.type: Easing.OutQuad
          }
          PropertyAnimation {
            property: "opacity"
            from: 1
            to: 0
            duration: 200
          }
        }
      }
    }

    Component.onCompleted: {
      Dat.Globals.trayPopup = trayPopup;
    }
    
    onClosed: {
      // Clear the stack when popup closes
      menuStackView.clear();
      systemTray.currentTrayIndex = -1;
    }
  }
}

