pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import "../Data/" as Dat
import "../Generics/" as Gen
import "../Widgets/" as Wid

Rectangle {
  id: root
  property int index: SwipeView.index
  property bool isCurrent: SwipeView.isCurrentItem
  color: "transparent"
  radius: 20
  
  // Network data properties
  property string currentConnection: "Not Connected"
  property string connectionType: "Unknown"
  property string uploadSpeed: "0 KB/s"
  property string downloadSpeed: "0 KB/s"
  property real uploadSpeedValue: 0
  property real downloadSpeedValue: 0
  property bool isConnected: false
  

  
  // Network monitoring processes
  Process {
    id: connectionInfo
    running: true
    command: ["sh", "-c", "nmcli -t -f NAME,TYPE,STATE connection show --active | grep -v ':loopback:' | head -1"]
    stdout: SplitParser {
      onRead: data => {
        if (data.trim()) {
          const parts = data.split(':');
          if (parts.length >= 3 && parts[2] === 'activated') {
            root.currentConnection = parts[0];
            root.connectionType = parts[1] === 'wifi' ? 'WiFi' : parts[1] === 'ethernet' ? 'Ethernet' : parts[1].toUpperCase();
            root.isConnected = true;
          } else {
            root.currentConnection = "Not Connected";
            root.isConnected = false;
          }
        } else {
          root.currentConnection = "Not Connected";
          root.isConnected = false;
        }
      }
    }
  }
  
  Process {
    id: speedInfo
    running: root.isConnected
    command: ["sh", "-c", "cat /proc/net/dev | grep -E '(wlan|eth|enp)' | head -1 | awk '{print $2,$10}'"]
    stdout: SplitParser {
      property var lastRx: 0
      property var lastTx: 0
      property var lastTime: Date.now()
      
      onRead: data => {
        if (data.trim()) {
          const parts = data.trim().split(' ');
          if (parts.length >= 2) {
            const currentTime = Date.now();
            const currentRx = parseInt(parts[0]);
            const currentTx = parseInt(parts[1]);
            
            if (lastRx > 0 && lastTx > 0) {
              const timeDiff = (currentTime - lastTime) / 1000;
              const rxSpeed = Math.max(0, (currentRx - lastRx) / timeDiff);
              const txSpeed = Math.max(0, (currentTx - lastTx) / timeDiff);
              
              root.downloadSpeed = formatSpeed(rxSpeed);
              root.uploadSpeed = formatSpeed(txSpeed);
              root.downloadSpeedValue = rxSpeed;
              root.uploadSpeedValue = txSpeed;
            }
            
            lastRx = currentRx;
            lastTx = currentTx;
            lastTime = currentTime;
          }
        }
      }
    }
  }
  
  Timer {
    interval: 2000
    repeat: true
    running: true
    onTriggered: {
      connectionInfo.running = true;
      if (root.isConnected) {
        speedInfo.running = true;
      }
    }
  }
  
  function formatSpeed(bytesPerSecond) {
    if (bytesPerSecond < 1024) return Math.round(bytesPerSecond) + " B/s";
    if (bytesPerSecond < 1024 * 1024) return (bytesPerSecond / 1024).toFixed(1) + " KB/s";
    if (bytesPerSecond < 1024 * 1024 * 1024) return (bytesPerSecond / (1024 * 1024)).toFixed(1) + " MB/s";
    return (bytesPerSecond / (1024 * 1024 * 1024)).toFixed(1) + " GB/s";
  }
  
  function formatProgress(speedValue) {
    // Normalize speed to percentage (0-100) based on 10MB/s max
    const maxSpeed = 10 * 1024 * 1024; // 10 MB/s in bytes
    return Math.min((speedValue / maxSpeed) * 100, 100);
  }
  
  function getConnectionIcon(type) {
    switch(type) {
      case 'WiFi': return "󰤨";
      case 'Ethernet': return "󰈀";
      default: return "󰲝";
    }
  }

  RowLayout {
    anchors.fill: parent
    spacing: 0
    
    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      clip: true
      color: Dat.Colors.surface_container_high
      radius: 10
      
      ColumnLayout {
        id: rightArea
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: 13
        anchors.top: parent.top
        spacing: 7
        
        // Side-by-side Circular Progress
        Rectangle {
          Layout.fillHeight: true
          Layout.fillWidth: true
          color: Dat.Colors.surface_container
          radius: 10
          
          RowLayout {
            anchors.fill: parent
            anchors.margins: 7
            spacing: 8
            
            Repeater {
              id: networkRepeater
              
              model: [
                {
                  icon: "",
                  label: "Download"
                },
                {
                  icon: "",
                  label: "Upload"
                }
              ]
              
              delegate: Item {
                id: itemRoot
                
                required property int index
                required property var modelData
                property string speed: (index === 0) ? root.downloadSpeed : root.uploadSpeed
                property real speedValue: (index === 0) ? root.downloadSpeedValue : root.uploadSpeedValue
                property color circleColor: (index === 0) ? Dat.Colors.primary : Dat.Colors.secondary
                
                Layout.fillHeight: true
                Layout.fillWidth: true
                
                Gen.CircularProgress {
                  anchors.centerIn: parent
                  size: Math.max(80, Math.min(parent.width, parent.height))
                  value: formatProgress(itemRoot.speedValue) / 100
                  primaryColor: itemRoot.circleColor
                  secondaryColor: Dat.Colors.primary_container
                  lineWidth: 7

                  Text {
                    anchors.centerIn: parent
                    text: itemRoot.speed
                    color: Dat.Colors.primary
                    font.pointSize: 12 * Dat.Globals.notchScale
                  }

                  Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: this.anchors.rightMargin
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    color: Dat.Colors.primary
                    height: this.width
                    radius: this.width
                    width: 30

                    Text {
                      anchors.centerIn: parent
                      color: Dat.Colors.on_primary
                      font.pointSize: 16
                      text: itemRoot.modelData.icon
                    }
                  }
                }
              }
            }
          }
        }
        
        // Connection Info at Bottom - Small Text
        Rectangle {
          Layout.alignment: Qt.AlignCenter
          Layout.fillWidth: true
          Layout.preferredHeight: 23
          color: "transparent"
          
          ColumnLayout {
            anchors.fill: parent
            spacing: 2
            
            Text {
              text: root.currentConnection
              color: Dat.Colors.on_surface
              font.pointSize: 9 * Dat.Globals.notchScale
              font.bold: true
              Layout.fillWidth: true
              horizontalAlignment: Text.AlignHCenter
            }
            
            Text {
              text: root.connectionType + (root.isConnected ? " • Connected" : " • Disconnected")
              color: root.isConnected ? Dat.Colors.on_surface_variant : Dat.Colors.error
              font.pointSize: 7 * Dat.Globals.notchScale
              Layout.alignment: Qt.AlignHCenter
              horizontalAlignment: Text.AlignHCenter
            }
          }
        }
      }
    }
    
    Item {
      Layout.fillHeight: true
      implicitWidth: 30 * Dat.Globals.notchScale
      
      ColumnLayout {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        
        Wid.SessionDots {
        }
      }
    }
  }
}
