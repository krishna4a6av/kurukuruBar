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
  color: Dat.Colors.surface_container_highest
  radius: 20 * Dat.Globals.notchScale
  property int index: SwipeView.index
  property bool isCurrent: SwipeView.isCurrentItem
  
  // Network data
  property string currentConnection: "Not Connected"
  property string connectionType: "Unknown"
  property string uploadSpeed: "0 KB/s"
  property string downloadSpeed: "0 KB/s"
  property real uploadSpeedValue: 0
  property real downloadSpeedValue: 0
  property bool isConnected: false
  property string activeInterface: ""
  
  // Debug: Get all network interfaces
  Process {
    id: interfaceDebug
    running: true
    command: ["sh", "-c", "cat /proc/net/dev | tail -n +3 | awk -F: '{print $1}' | sed 's/^[[:space:]]*//'"]
    stdout: SplitParser {
      onRead: data => {
      }
    }
  }
  
  // Get active interface name
  Process {
    id: activeInterfaceInfo
    running: true
    command: ["sh", "-c", "ip route get 8.8.8.8 2>/dev/null | grep -Po '(?<=dev )\\S+' | head -1"]
    stdout: SplitParser {
      onRead: data => {
        if (data.trim()) {
          root.activeInterface = data.trim();
        }
      }
    }
  }
  
  // Active connection info
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
  
  // Speed monitoring - universal method using active interface
  Process {
    id: speedInfo
    running: root.isConnected && root.activeInterface !== ""
    command: ["sh", "-c", `cat /proc/net/dev | grep "${root.activeInterface}:" | awk -F: '{print $2}' | awk '{print $1,$9}'`]
    stdout: SplitParser {
      property var lastRx: 0
      property var lastTx: 0
      property var lastTime: Date.now()
      
      onRead: data => {
        if (data.trim() && data.trim() !== "0 0") {
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
        } else if (data.trim() === "0 0") {
          // Try alternative method using ip command
          fallbackSpeedInfo.running = true;
        }
      }
    }
  }
  
  // Fallback method using ip command
  Process {
    id: fallbackSpeedInfo
    running: false
    command: ["sh", "-c", `ip -s link show ${root.activeInterface} | grep -A1 "RX:" | tail -1 | awk '{print $1}'; ip -s link show ${root.activeInterface} | grep -A1 "TX:" | tail -1 | awk '{print $1}'`]
    stdout: SplitParser {
      property var lastRx: 0
      property var lastTx: 0
      property var lastTime: Date.now()
      property var lineCount: 0
      property var tempRx: 0
      
      onRead: data => {
        const lines = data.trim().split('\n');
        for (let i = 0; i < lines.length; i++) {
          const line = lines[i].trim();
          if (line && !isNaN(parseInt(line))) {
            if (lineCount % 2 === 0) {
              tempRx = parseInt(line);
            } else {
              const currentTime = Date.now();
              const currentRx = tempRx;
              const currentTx = parseInt(line);
              
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
            lineCount++;
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
      activeInterfaceInfo.running = true;
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
    const maxSpeed = 10 * 1024 * 1024;
    return Math.min((speedValue / maxSpeed) * 100, 100);
  }
  
  function getConnectionIcon(type) {
    switch (type) {
      case "WiFi":
      case "802-11-WIRELESS": 
        return "󰤨";
      case "Ethernet": 
        return "󰈀";
      default: 
        return "󰲝";
    }
  }
  
  RowLayout {
    anchors.fill: parent
    spacing: 10 * Dat.Globals.notchScale
    
    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      clip: true
      radius: 20 * Dat.Globals.notchScale
      color: "transparent"
      
      ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8 * Dat.Globals.notchScale
        spacing: 5 * Dat.Globals.notchScale
        
        // Progress meters
        Rectangle {
          Layout.fillHeight: true
          Layout.fillWidth: true
          Layout.preferredHeight: 130 * Dat.Globals.notchScale
          Layout.maximumHeight: 130 * Dat.Globals.notchScale
          radius: 20 * Dat.Globals.notchScale
          color: Dat.Colors.surface_container
          
          RowLayout {
            anchors.fill: parent
            spacing: 8 * Dat.Globals.notchScale
            
            Repeater {
              model: [
                { icon: "", label: "Download" },
                { icon: "", label: "Upload" }
              ]
              delegate: Item {
                required property int index
                required property var modelData
                property string speed: (index === 0) ? root.downloadSpeed : root.uploadSpeed
                property real speedValue: (index === 0) ? root.downloadSpeedValue : root.uploadSpeedValue
                property color circleColor: (index === 0) ? Dat.Colors.primary : Dat.Colors.secondary
                
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                Item {
                  anchors.fill: parent
                  
                  Gen.CircularProgress {
                    anchors.centerIn: parent
                    size: Math.min(parent.width, parent.height) * 0.96
                    value: formatProgress(speedValue) / 100
                    primaryColor: circleColor
                    secondaryColor: Dat.Colors.primary_container
                    lineWidth: 7 * Dat.Globals.notchScale
                    rotation: -205
                    degreeLimit: 290
                  }
                  
                  Text {
                    anchors.centerIn: parent
                    text: speed
                    color: Dat.Colors.primary
                    font.bold: true
                    font.pointSize: 13 * Dat.Globals.notchScale
                  }
                  
                  Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: 8 * Dat.Globals.notchScale
                    width: 35 * Dat.Globals.notchScale
                    height: 35 * Dat.Globals.notchScale
                    radius: 17.5 * Dat.Globals.notchScale
                    color: Dat.Colors.primary
                    
                    Text {
                      anchors.centerIn: parent
                      text: modelData.icon
                      font.pointSize: 15 * Dat.Globals.notchScale
                      color: Dat.Colors.on_primary
                    }
                  }
                }
              }
            }
          }
        }
        
        Rectangle {
          id: connectionInfoLayout
          Layout.fillWidth: true
          color: "transparent"
          implicitHeight: 23 * Dat.Globals.notchScale
          radius: 20 * Dat.Globals.notchScale
          
          RowLayout {
            anchors.fill: parent
            
            // Left: Connection name
            Rectangle {
              Layout.fillWidth: true
              Layout.preferredWidth: 100
              color: "transparent"
              
              Text {
                anchors.fill: parent
                anchors.margins: 15 * Dat.Globals.notchScale
                text: root.currentConnection + " " +(root.activeInterface ? "(" + root.activeInterface + ")" : "")
                color: Dat.Colors.on_surface
                font.bold: true
                font.pointSize: 9 * Dat.Globals.notchScale
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
              }
            }

            // Right: Connection type and interface
            Rectangle {
              Layout.fillWidth: true
              Layout.preferredWidth: 80 * Dat.Globals.notchScale
              Layout.rightMargin: 10
              color: "transparent"
              
              Text {
                anchors.fill: parent
                anchors.margins: 2 * Dat.Globals.notchScale
                text: getConnectionIcon(root.connectionType) + "  " + (root.isConnected ? "Connected" : "Disconnected")
                color: Dat.Colors.on_surface
                font.pointSize: 8 * Dat.Globals.notchScale
                font.bold: true
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
              }
            }
          }
        }
      }
    }
  }
}
