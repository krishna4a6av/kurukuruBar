pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: root
  required property QsMenuOpener trayMenu
  
  // Add signals for navigation
  signal navigateToSubmenu(var submenu)
  signal navigateBack()
  
  clip: true
  color: Dat.Colors.surface_container
  radius: 8 * Dat.Globals.notchScale
  
  ListView {
    id: view
    anchors.fill: parent
    spacing: 1 * Dat.Globals.notchScale
    delegate: Rectangle {
      id: entry
      property var child: QsMenuOpener {
        menu: entry.modelData
      }
      required property QsMenuEntry modelData
      color: (modelData?.isSeparator) ? Dat.Colors.outline : "transparent"
      height: (modelData?.isSeparator) ? 2 * Dat.Globals.notchScale : 28 * Dat.Globals.notchScale
      radius: 20 * Dat.Globals.notchScale
      width: root.width
      
      Gen.MouseArea {
        layerColor: text.color
        visible: (entry.modelData?.enabled && !entry.modelData?.isSeparator) ?? true
        onClicked: {
          if (entry.modelData?.hasChildren) {
            // Creates a new TrayItemMenu for the submenu instead of reassigning trayMenu
            var submenu = Qt.createComponent("TrayItemMenu.qml").createObject(root.parent, {
              trayMenu: entry.child,
              width: root.width,
              height: root.height
            });
            
            // Connect the submenu's navigation signals
            submenu.navigateToSubmenu.connect(root.navigateToSubmenu);
            submenu.navigateBack.connect(root.navigateBack);
            
            root.navigateToSubmenu(submenu);
          } else {
            entry.modelData?.triggered();
          }
        }
      }
      
      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: (entry.modelData?.buttonType == QsMenuButtonType.None) ? 10 * Dat.Globals.notchScale : 2 * Dat.Globals.notchScale
        anchors.rightMargin: 10 * Dat.Globals.notchScale
        
        Item {
          Layout.fillHeight: true
          implicitWidth: this.height
          visible: (entry.modelData?.buttonType == QsMenuButtonType.CheckBox) ?? false
          Gen.MatIcon {
            anchors.centerIn: parent
            color: Dat.Colors.primary
            fill: (entry.modelData?.checkState == Qt.Checked) ?? false
            font.pixelSize: (parent.width * 0.8) * Dat.Globals.notchScale
            icon: ((entry.modelData?.checkState != Qt.Checked) ?? true) ? "󰄮" : "󰄲"
          }
        }
        
        // untested cause nothing I use have radio buttons
        // if you use this and find somethings wrong / "yes rexi everything is fine" lemme know by opening an issue
        // untested by me as well :[]
        Item {
          Layout.fillHeight: true
          implicitWidth: this.height
          visible: (entry.modelData?.buttonType == QsMenuButtonType.RadioButton) ?? false
          Gen.MatIcon {
            anchors.centerIn: parent
            color: Dat.Colors.primary
            fill: (entry.modelData?.checkState == Qt.Checked) ?? false
            font.pixelSize: (parent.width * 0.8) * Dat.Globals.notchScale
            icon: ((entry.modelData?.checkState != Qt.Checked) ?? true) ? "radio_button_unchecked" : "radio_button_checked"
          }
        }
        
        Rectangle {
          Layout.fillHeight: true
          Layout.fillWidth: true
          color: "transparent"
          Text {
            id: text
            anchors.fill: parent
            color: (entry.modelData?.enabled ?? true) ? Dat.Colors.on_surface : Dat.Colors.primary
            font.pointSize: 10 * Dat.Globals.notchScale
            text: entry.modelData?.text ?? ""
            verticalAlignment: Text.AlignVCenter
          }
        }
        
        Item {
          Layout.fillHeight: true
          implicitWidth: this.height
          visible: (entry.modelData?.icon ?? false) ? true : false
          Image {
            anchors.fill: parent
            anchors.margins: 3 * Dat.Globals.notchScale
            fillMode: Image.PreserveAspectFit
            source: entry.modelData?.icon ?? ""
          }
        }
        
        Item {
          Layout.fillHeight: true
          implicitWidth: this.height
          visible: (entry.modelData?.hasChildren ?? false)
          Text {
            anchors.centerIn: parent
            color: Dat.Colors.on_surface
            font.pointSize: 10 * Dat.Globals.notchScale
            text: "▶"
          }
        }
      }
    }
    
    model: ScriptModel {
      // Add null check to prevent undefined errors
      values: root.trayMenu?.children?.values ? [...root.trayMenu.children.values] : []
    }
  }
}
