pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import "../Generics/" as Gen
import "../Data/" as Dat
import "../Widgets/" as Wid

Rectangle {
  color: "transparent"
  
  property bool themeSelectorExpanded: false
  
  RowLayout {
    anchors.fill: parent
    anchors.margins: 10 * Dat.Globals.notchScale
    spacing: 10 * Dat.Globals.notchScale
    
    // Left side - Greeting and mssg | op's greeting widget
    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: !themeSelectorExpanded
      Layout.rightMargin: 10*Dat.Globals.notchScale
      Layout.preferredWidth: themeSelectorExpanded ? 75 * Dat.Globals.notchScale : 100 * Dat.Globals.notchScale
      Layout.minimumWidth: themeSelectorExpanded ? 60 * Dat.Globals.notchScale : 100 * Dat.Globals.notchScale
      color: "transparent"

      Rectangle{
        anchors.fill: parent
        color: themeSelectorExpanded ? "transparent" : Dat.Colors.surface_container
        radius: 20 * Dat.Globals.notchScale
      }
      
      Behavior on Layout.preferredWidth {
        NumberAnimation {
          duration: 300
          easing.type: Easing.OutCubic
        }
      }
      
      StackView {
        id: stack
        anchors.fill: parent
        visible: !themeSelectorExpanded
        opacity: themeSelectorExpanded ? 0 : 1
        
        Behavior on opacity {
          NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
          }
        }
        
        initialItem: Wid.GreeterWidget {
          height: stack.height
          width: stack.width
        }
        
        popEnter: Transition {
          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
              from: 0
              property: "opacity"
              to: 1
            }
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
              from: -100 * Dat.Globals.notchScale
              property: "y"
            }
          }
        }
        
        popExit: Transition {
          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedTime
              easing.bezierCurve: Dat.MaterialEasing.emphasized
              from: 1
              property: "opacity"
              to: 0
            }
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedAccelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
              property: "y"
              to: 100 * Dat.Globals.notchScale
            }
          }
        }
        
        pushEnter: Transition {
          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedTime
              easing.bezierCurve: Dat.MaterialEasing.emphasized
              from: 0
              property: "opacity"
              to: 1
            }
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
              from: 100 * Dat.Globals.notchScale
              property: "y"
            }
          }
        }
        
        pushExit: Transition {
          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedTime
              easing.bezierCurve: Dat.MaterialEasing.emphasized
              from: 1
              property: "opacity"
              to: 0
            }
          }
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedAccelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
            property: "y"
            to: -100 * Dat.Globals.notchScale
          }
        }
        
        replaceEnter: Transition {
          ParallelAnimation {
            PropertyAnimation {
              duration: 0
              property: "opacity"
              to: 1
            }
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
              from: 100 * Dat.Globals.notchScale
              property: "y"
            }
          }
        }
        
        replaceExit: Transition {
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedAccelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
            from: 1
            property: "opacity"
            to: 0
          }
        }
      }
      
      // Current theme display when greeter is collapsed
      Rectangle {
        anchors.fill: parent
        anchors.leftMargin: 20 * Dat.Globals.notchScale
        visible: themeSelectorExpanded
        opacity: themeSelectorExpanded ? 1 : 0
        color: "transparent"

        Rectangle {
          anchors.fill: parent
          color: Dat.Colors.primary
          radius: 20 * Dat.Globals.notchScale
        }
        
        Behavior on opacity {
          NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
          }
        }
        
        ColumnLayout {
          anchors.centerIn: parent
          spacing: 8 * Dat.Globals.notchScale
          
          // Current theme name (vertical)
          Text {
            Layout.alignment: Qt.AlignHCenter
            text: Dat.ThemeManager.getThemeName()

            font.pixelSize: 14 * Dat.Globals.notchScale
            font.weight: Font.Bold
            rotation: -90
            color: Dat.Colors.on_primary
            horizontalAlignment: Text.AlignHCenter
            lineHeight: 1
          }
        }
        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
            
          onClicked: {
            themeSelectorExpanded = false
          }
        }
      }
    }
    
    // Right side - Collapsible Theme Selector
    Rectangle {
      Layout.fillHeight: true
      Layout.preferredWidth: themeSelectorExpanded ? 190 * Dat.Globals.notchScale : 55 * Dat.Globals.notchScale
      Layout.minimumWidth: themeSelectorExpanded ? 180 * Dat.Globals.notchScale : 50 * Dat.Globals.notchScale
      Layout.rightMargin: 10
      color: Dat.Colors.surface_container
      radius: 20 * Dat.Globals.notchScale
      
      Behavior on Layout.preferredWidth {
        NumberAnimation {
          duration: 300
          easing.type: Easing.OutCubic
        }
      }
      
      // Collapsed state - Vertical "Themes" button
      Rectangle {
        anchors.fill: parent
        visible: !themeSelectorExpanded
        color: "transparent"
        
        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          
          onClicked: {
            themeSelectorExpanded = true
          }
          
          Rectangle {
            anchors.fill: parent
            color: parent.containsMouse ? Dat.Colors.secondary_container : Dat.Colors.primary
            radius: 20 * Dat.Globals.notchScale
            
            Behavior on color {
              ColorAnimation {
                duration: 200
                easing.type: Easing.OutCubic
              }
            }
          }
        }
        
        Text {
          anchors.centerIn: parent
          text: "T\nH\nE\nM\nE\nS"
          font.pixelSize: 14 * Dat.Globals.notchScale
          font.bold: true
          color: Dat.Colors.on_primary
          horizontalAlignment: Text.AlignHCenter
          lineHeight: 0.9
        }
      }
      
      // Expanded state - Full theme selector
      RowLayout {
        anchors.fill: parent
        anchors.margins: 13 * Dat.Globals.notchScale
        spacing: 8 * Dat.Globals.notchScale
        visible: themeSelectorExpanded

        //Theme selection scroll
        ScrollView {
          Layout.fillWidth: true
          Layout.fillHeight: true
          contentWidth: availableWidth

          ScrollBar.vertical.policy: ScrollBar.AlwaysOff
          
          ColumnLayout {
            width: parent.width
            spacing: 8 * Dat.Globals.notchScale
            
            Repeater {
              model: Dat.ThemeManager.themes
              delegate: Rectangle {
                required property int index
                required property var modelData
                
                Layout.fillWidth: true
                Layout.preferredHeight: 40 * Dat.Globals.notchScale
                
                color: mouseArea.containsMouse ? 
                       Dat.Colors.surface_container_high : 
                       (index === Dat.ThemeManager.currentThemeIndex ? 
                        Dat.Colors.primary_container : 
                        Dat.Colors.surface_container_low)
                
                radius: 12 * Dat.Globals.notchScale
                border.width: (index === Dat.ThemeManager.currentThemeIndex ? 3 : 1) * Dat.Globals.notchScale
                border.color: index === Dat.ThemeManager.currentThemeIndex ? 
                             Dat.Colors.primary : 
                             Dat.Colors.outline_variant
                
                Behavior on color {
                  ColorAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                  }
                }
                
                Behavior on border.color {
                  ColorAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                  }
                }

                RowLayout {
                  anchors.fill: parent
                  anchors.margins: 9 * Dat.Globals.notchScale
                  spacing: 10 * Dat.Globals.notchScale

                  //Left dot on the themes list
                  Rectangle {
                    Layout.preferredWidth: 14 * Dat.Globals.notchScale
                    Layout.preferredHeight: 14 * Dat.Globals.notchScale
                    radius: 8 * Dat.Globals.notchScale
                    color: index === Dat.ThemeManager.currentThemeIndex ? 
                           Dat.Colors.primary : 
                           Dat.Colors.outline_variant
                    
                    Rectangle {
                      anchors.centerIn: parent
                      width: 10 * Dat.Globals.notchScale
                      height: 10 * Dat.Globals.notchScale
                      radius: 6 * Dat.Globals.notchScale
                      color: Dat.Colors.on_primary
                      visible: index === Dat.ThemeManager.currentThemeIndex
                    }
                  }
                  
                  //Theme name text
                  Text {
                    Layout.fillWidth: true
                    text: modelData.name
                    font.pixelSize: 13 * Dat.Globals.notchScale
                    font.weight: index === Dat.ThemeManager.currentThemeIndex ? 
                                Font.DemiBold : Font.Normal
                    color: index === Dat.ThemeManager.currentThemeIndex ? 
                           Dat.Colors.on_primary_container : 
                           Dat.Colors.on_surface
                    verticalAlignment: Text.AlignVCenter
                  }

                  //Tick on right of active theme
                  Text {
                    Layout.preferredWidth: 15 * Dat.Globals.notchScale
                    Layout.preferredHeight: 12 * Dat.Globals.notchScale
                    text: "✓"
                    font.pixelSize: 14 * Dat.Globals.notchScale
                    font.weight: Font.Bold
                    color: Dat.Colors.primary
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: index === Dat.ThemeManager.currentThemeIndex
                  }
                }
                
                MouseArea {
                  id: mouseArea
                  anchors.fill: parent
                  hoverEnabled: true
                  cursorShape: Qt.PointingHandCursor
                  
                  onClicked: {
                    if (index !== Dat.ThemeManager.currentThemeIndex) {
                      Dat.ThemeManager.switchToTheme(index)
                    }
                  }
                }
              }
            }
            
            Item {
              Layout.fillHeight: true
            }
          }
        }
        
        // Close button positioned at far-right
        Item {
          Layout.fillWidth: true
          Layout.preferredHeight: 40 * Dat.Globals.notchScale
            
          Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 0
            anchors.leftMargin: 0
            width: 24 * Dat.Globals.notchScale
            height: 24 * Dat.Globals.notchScale
            radius: 12 * Dat.Globals.notchScale
            color: closeMouseArea.containsMouse ? Dat.Colors.surface_container_high : "transparent"
              
            Behavior on color {
              ColorAnimation {
                duration: 200
                easing.type: Easing.OutCubic
              }
            }
              
            Text {
              anchors.centerIn: parent
              text: ""
              font.pixelSize: 13 * Dat.Globals.notchScale
              font.weight: Font.Bold
              color: Dat.Colors.on_surface
            }
              
            MouseArea {
              id: closeMouseArea
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
                
              onClicked: {
                themeSelectorExpanded = false
              }
            }
          }
        }
        
      }
    }
  }
}
