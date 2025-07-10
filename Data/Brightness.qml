pragma Singleton
import QtQuick
import Quickshell.Io

Item {
  property var currentBrightness: 0
  property var currentBrightnessPercent: 0

  function decrease() {
    getBrightnessPercentForAdjustment.adjustmentType = "decrease";
    getBrightnessPercentForAdjustment.running = true;
  }

  function increase() {
    getBrightnessPercentForAdjustment.adjustmentType = "increase";
    getBrightnessPercentForAdjustment.running = true;
  }

  function getCurrentBrightness() {
    getBrightness.running = true;
    return currentBrightness;
  }

  function getCurrentBrightnessPercent() {
    getBrightnessPercent.running = true;
    return currentBrightnessPercent;
  }

  // Regular brightness steps
  Process {
    id: inc
    command: ["brightnessctl", "set", "5%+"]
  }

  Process {
    id: dec
    command: ["brightnessctl", "set", "5%-"]
  }

  // Small brightness steps for low ranges
  Process {
    id: incSmall
    command: ["brightnessctl", "set", "1%+"]
  }

  Process {
    id: decSmall
    command: ["brightnessctl", "set", "1%-"]
  }

  // Adjust brightness based on percent
  // so 5% change when greater than 10% and 1% change when <= 10%
  Process {
    id: getBrightnessPercentForAdjustment
    command: ["sh", "-c", "brightnessctl | grep -oP '\\(\\K[0-9]+(?=%)'"]
    property string adjustmentType: ""
    stdout: SplitParser {
      onRead: data => {
        let output = String(data).trim();

        let percent = parseInt(output);
        if (!isNaN(percent)) {
          if (getBrightnessPercentForAdjustment.adjustmentType === "increase") {
            if (percent >= 100) return;
            (percent <= 10 ? incSmall : inc).running = true;
          } else if (getBrightnessPercentForAdjustment.adjustmentType === "decrease") {
            if (percent <= 1) return;
            (percent <= 10 ? decSmall : dec).running = true;
          }
        } else {
          console.warn("Could not parse brightness percent:", output);
        }
      }
    }
  }

  // Get raw brightness value (gives value)
  Process {
    id: getBrightness
    command: ["brightnessctl", "get"]
    onExited: function(exitCode, stdout) {
      if (exitCode === 0 && stdout) {
        currentBrightness = String(stdout).trim();
      }
    }
  }

  // Get current brightness percentage (for UI)
  Process {
    id: getBrightnessPercent
    command: ["sh", "-c", "brightnessctl | grep -oP '\\(\\K[0-9]+(?=%)'"]
    stdout: SplitParser {
      onRead: data => {
        let output = String(data).trim();
        let percent = parseInt(output);
        if (!isNaN(percent)) {
          currentBrightnessPercent = percent;
        }
      }
    }
  }

  // Periodic polling to keep values updated
  Timer {
    id: brightnessTimer
    interval: 500
    repeat: true
    running: true
    onTriggered: {
      getBrightness.running = true;
      getBrightnessPercent.running = true;
    }
  }
}

