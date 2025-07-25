pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell.Services.Mpris
import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: rect

  required property MprisPlayer player

  clip: true
  color: Dat.Colors.surface_container_low
  radius: 20 * Dat.Globals.notchScale

  Image {
    id: imgDisk

    anchors.horizontalCenter: rect.horizontalCenter
    fillMode: Image.PreserveAspectCrop
    height: this.width
    layer.enabled: true
    layer.smooth: true
    mipmap: true
    rotation: 0
    smooth: true
    source: player.trackArtUrl
    width: rect.width - (60 * Dat.Globals.notchScale)
    y: 80 * Dat.Globals.notchScale

    layer.effect: MultiEffect {
      antialiasing: true
      maskEnabled: true
      maskSpreadAtMin: 1.0
      maskThresholdMax: 1.0
      maskThresholdMin: 0.5

      maskSource: Image {
        layer.smooth: true
        mipmap: true
        smooth: true
        source: "../Assets/AlbumCover-by-Squirrel-Modeller.svg"
      }
    }
    Behavior on rotation {
      NumberAnimation {
        duration: rotateTimer.interval
        easing.type: Easing.Linear
      }
    }
    Behavior on scale {
      NumberAnimation {
        duration: Dat.MaterialEasing.emphasizedTime
        easing.bezierCurve: Dat.MaterialEasing.emphasized
      }
    }
  }
  //Signals for keybinds
  Component.onCompleted: {
    // Set this as the active player when music view is shown
    // otherwise all players are simultaneously changed
    if (Dat.Globals.swipeIndex === 3) {
      Dat.Globals.activeMusicPlayer = player;
    }
    
    Dat.Globals.swipeIndexChanged.connect(() => {
      if (Dat.Globals.swipeIndex === 3) {
        Dat.Globals.activeMusicPlayer = player;
      }
    });
    
    Dat.Globals.toggleMusicPlayback.connect(() => {
      if (Dat.Globals.activeMusicPlayer === player) {
        player.togglePlaying();
      }
    });
  
    Dat.Globals.previousTrack.connect(() => {
      if (Dat.Globals.activeMusicPlayer === player) {
        player.previous();
      }
    });
    
    Dat.Globals.nextTrack.connect(() => {
      if (Dat.Globals.activeMusicPlayer === player) {
        player.next();
      }
    });
  }

  MouseArea {
    id: diskMouseArea

    anchors.bottom: rect.bottom
    anchors.left: rect.left
    anchors.right: rect.right

    // wonky but required
    height: rect.height * 0.40
    hoverEnabled: true

    onClicked: mevent => {
      rect.player.togglePlaying();
    }
    onEntered: {
      imgDisk.scale = 0.8;
    }
    onExited: {
      imgDisk.scale = 1;
    }
  }

  Timer {
    id: rotateTimer

    interval: 500
    repeat: true
    running: Dat.Globals.notchState == "FULLY_EXPANDED" && Dat.Globals.swipeIndex == 3 && rect.player.isPlaying

    onRunningChanged: {
      // better hack to not wait for interval completion on quick state changes
      imgDisk.rotation += (rotateTimer.running) ? 3 : 0;
    }
    onTriggered: imgDisk.rotation += 3
  }

  Timer {
    id: mprisDotRotateTimer

    interval: 500
    repeat: true
    running: Dat.Globals.notchState != "COLLAPSED" && rect.player.isPlaying

    onRunningChanged: {
      Dat.Globals.mprisDotRotation += (mprisDotRotateTimer.running) ? 6 : 0;
    }
    onTriggered: Dat.Globals.mprisDotRotation += 6
  }

  ColumnLayout {
    anchors.bottom: imgDisk.top
    anchors.bottomMargin: 5 * Dat.Globals.notchScale
    anchors.left: parent.left
    anchors.margins: 10 * Dat.Globals.notchScale
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.topMargin: 0
    spacing: 0

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredHeight: 2
      color: "transparent"

      Text {
        anchors.fill: parent
        color: Dat.Colors.primary
        elide: Text.ElideRight
        font.bold: true
        font.pointSize: 13 * Dat.Globals.notchScale
        horizontalAlignment: Text.AlignHCenter
        text: player.trackTitle
        verticalAlignment: Text.AlignBottom
      }
    }

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      color: "transparent"

      Text {
        anchors.fill: parent
        color: Dat.Colors.secondary
        elide: Text.ElideRight
        font.bold: true
        font.pointSize: 9 * Dat.Globals.notchScale
        horizontalAlignment: Text.AlignHCenter
        text: player.trackArtist
        verticalAlignment: Text.AlignTop
      }
    }
  }

  Rectangle {
    anchors.left: rect.left
    anchors.leftMargin: 20 * Dat.Globals.notchScale
    anchors.verticalCenter: rect.verticalCenter
    color: "transparent"
    height: 25 * Dat.Globals.notchScale
    width: 25 * Dat.Globals.notchScale

    Gen.MatIcon {
      id: prevIcon

      anchors.centerIn: parent
      color: Dat.Colors.secondary
      font.bold: true
      font.pixelSize: 30 * Dat.Globals.notchScale
      icon: "󰒮"
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true

      onClicked: {
        rect.player.previous();
      }
      onEntered: prevIcon.fill = 1
      onExited: prevIcon.fill = 0
    }
  }

  Rectangle {
    anchors.right: rect.right
    anchors.rightMargin: 20 * Dat.Globals.notchScale
    anchors.verticalCenter: rect.verticalCenter
    color: "transparent"
    height: 25 * Dat.Globals.notchScale
    width: 25 * Dat.Globals.notchScale

    Gen.MatIcon {
      id: nextIcon

      anchors.centerIn: parent
      color: Dat.Colors.secondary
      font.bold: true
      font.pixelSize: 30 * Dat.Globals.notchScale
      icon: "󰒭"
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true

      onClicked: {
        rect.player.next();
      }
      onEntered: nextIcon.fill = 1
      onExited: nextIcon.fill = 0
    }
  }
}
