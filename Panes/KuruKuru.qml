import QtQuick
import QtQuick.Particles
import QtQuick.Layouts
import QtQuick.Effects

import "../Data/" as Dat
import "../Widgets/" as Wid

Rectangle {
  color: "transparent"

  RowLayout {
    anchors.fill: parent
    spacing: 10 * Dat.Globals.notchScale

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredWidth: 1.45
      color: "transparent"

      RowLayout {
        anchors.fill: parent
        spacing: 10 * Dat.Globals.notchScale

        Text {
          id: muteIcon

          property bool muted: false

          Layout.fillHeight: true
          Layout.fillWidth: true
          Layout.leftMargin: 10 * Dat.Globals.notchScale
          color: Dat.Colors.on_surface
          font.pixelSize: 16 * Dat.Globals.notchScale
          horizontalAlignment: Text.AlignRight
          text: (muted) ? "󰖁" : "󰕾"
          verticalAlignment: Text.AlignVCenter

          MouseArea {
            anchors.fill: parent

            onClicked: parent.muted = !parent.muted
          }
        }

        Text {
          id: kuruText

          Layout.fillHeight: true
          Layout.fillWidth: true
          color: Dat.Colors.on_surface
          font.pixelSize: 16 * Dat.Globals.notchScale
          horizontalAlignment: Text.AlignLeft
          text: "くるくる～――っと。"
          verticalAlignment: Text.AlignVCenter
        }
      }

      Wid.NotifDots {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10 * Dat.Globals.notchScale
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent" //Dat.Colors.surface_container
        height: 28 * Dat.Globals.notchScale
        radius: 20 * Dat.Globals.notchScale
      }
    }

    ColumnLayout {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredWidth: 1

      Rectangle { // the hando that squishes the kuru kuru
        id: squishRect

        Layout.fillWidth: true
        color: "transparent"
        implicitHeight: 0
        state: "NOSQUISH"

        states: [
          State {
            name: "NOSQUISH"

            PropertyChanges {
              squishRect.implicitHeight: 0
            }
          },
          State {
            name: "SQUISH"

            PropertyChanges {
              squishRect.implicitHeight: 40 * Dat.Globals.notchScale
            }
          }
        ]
        transitions: [
          Transition {
            from: "NOSQUISH"
            to: "SQUISH"

            NumberAnimation {
              duration: 100
              easing.bezierCurve: Dat.MaterialEasing.standardAccel
              property: "implicitHeight"
            }
          },
          Transition {
            from: "SQUISH"
            to: "NOSQUISH"

            NumberAnimation {
              duration: Dat.MaterialEasing.standardDecelTime
              easing.bezierCurve: Dat.MaterialEasing.standardDecel
              property: "implicitHeight"
            }
          }
        ]
      }

      Rectangle {
        id: gifRect

        property bool playing: false
        property real speed: 0.8
        property bool switchable: true

        Layout.fillHeight: true
        Layout.fillWidth: true
        color: "transparent"
        state: "HERTA"

        states: [
          State {
            name: "HERTA"

            PropertyChanges {
              big.opacity: 0
              big.visible: false
              smoll.opacity: 1
              smoll.visible: true
            }
          },
          State {
            name: "THE_HERTA"

            PropertyChanges {
              big.opacity: 1
              big.visible: true
              smoll.opacity: 0
              smoll.visible: false
            }
          }
        ]
        transitions: [
          Transition {
            from: "HERTA"
            to: "THE_HERTA"

            SequentialAnimation {
              PropertyAction {
                property: "visible"
                target: big
              }

              NumberAnimation {
                duration: 500
                easing.type: Easing.Linear
                property: "opacity"
                targets: [big, smoll]
              }

              PropertyAction {
                property: "visible"
                target: smoll
              }
            }
          },
          Transition {
            from: "THE_HERTA"
            to: "HERTA"

            SequentialAnimation {
              PropertyAction {
                property: "visible"
                target: smoll
              }

              NumberAnimation {
                duration: 500
                easing.type: Easing.Linear
                property: "opacity"
                targets: [big, smoll]
              }

              PropertyAction {
                property: "visible"
                target: big
              }
            }
          }
        ]

        Component.onCompleted: {
          Dat.Globals.notchStateChanged.connect(() => {
            if (Dat.Globals.notchState == "FULLY_EXPANDED") {
              gifRect.playing = true;
            }
          });
        }
        onSpeedChanged: {
          if (gifRect.speed > 8) {
            if (gifRect.switchable) {
              gifRect.state = (gifRect.state == "HERTA") ? "THE_HERTA" : "HERTA";
            }
            gifRect.switchable = false;
          }
          if (gifRect.speed < 7) {
            gifRect.switchable = true;
          }

          if (gifRect.speed > 5) {
            pSystem.running = true;
          }

          if (gifRect.speed < 1) {
            pSystem.running = false;
          }
        }

        Timer {
          interval: 500
          running: Dat.Globals.notchState != "FULLY_EXPANDED" && parent.playing == true

          onTriggered: {
            parent.playing = false;
          }
        }

        Timer {
          id: squisher

          interval: 50
          repeat: true
          running: squishRect.state == "SQUISH"

          onTriggered: parent.speed += 0.1
        }

        Timer {
          id: stoptheKuruKuru

          interval: 50
          repeat: true
          running: squishRect.state != "SQUISH" && parent.speed > 0.8

          onTriggered: parent.speed -= 0.05
        }

        AnimatedImage {
          id: smoll

          anchors.fill: parent
          fillMode: Image.PreserveAspectCrop
          horizontalAlignment: Image.AlignRight
          playing: parent.playing && smoll.visible
          source: "../Assets/herta/smolHertaspin.gif"
          speed: parent.speed
        }

        AnimatedImage {
          id: big

          anchors.bottomMargin: -23 * Dat.Globals.notchScale
          anchors.fill: parent
          fillMode: Image.PreserveAspectFit
          horizontalAlignment: Image.AlignRight
          playing: parent.playing && big.visible
          source: "../Assets/herta/bigHertaspin.gif"
          speed: parent.speed
        }

        MouseArea {
          acceptedButtons: Qt.LeftButton
          anchors.fill: parent

          onPressedChanged: {
            squishRect.state = (squishRect.state == "SQUISH") ? "NOSQUISH" : "SQUISH";

            if (muteIcon.muted) {
              return;
            }
            if (Math.round((Math.random() * 10)) % 2 == 0) {
              // kurukuru.play();
              kuruText.text = "くるくる～――っと。";
            } else {
              // kururin.play();
              kuruText.text = "くるりん～っと。";
            }
          }
        }
      }
    }
  }

  Wid.KuruParticleSystem {
    id: pSystem

    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.top: parent.top
    layer.enabled: true
    rateMultiplier: gifRect.speed
    visible: false
    width: 700 * Dat.Globals.notchScale
  }

  MultiEffect {
    anchors.fill: pSystem
    maskEnabled: true
    maskSource: mask
    maskSpreadAtMin: 1.0
    maskThresholdMax: 1.0
    maskThresholdMin: 0.5
    source: pSystem
  }

  Item {
    id: mask

    height: pSystem.height
    layer.enabled: true
    visible: false
    width: pSystem.width

    Rectangle {
      anchors.fill: parent
      bottomLeftRadius: 20 * Dat.Globals.notchScale
      bottomRightRadius: 20 * Dat.Globals.notchScale
    }
  }
}
