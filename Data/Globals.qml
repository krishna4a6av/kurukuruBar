pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Singleton {
  id: root

  property string actWinName: activeWindow?.activated ? activeWindow?.appId : "desktop"
  readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
  property string hostName: "KuruMi"
  property real mprisDotRotation: 0
  property bool notchHovered: false

  // experimental, not reallllyyy recommended
  property real notchScale: 0.81

  // one of "COLLAPSED", "EXPANDED", "FULLY_EXPANDED","REST"
  property string notchState: (reservedShell) ? "EXPANDED" : "REST"
  // one of "HIDDEN", "POPUP", "INBOX"
  property string notifState: "HIDDEN"
  property bool reservedShell: false

  // SettingsView State
  // 0 => Power
  // 1 => Audio
  // 2 => Network
  property int settingsTabIndex: 0

  // Central Panel SwipeView stuff
  // 0 => Home
  // 1 => Calendar
  // 2 => System
  // 3 => Mpris
  // 4 => SettingsView
  property int swipeIndex: 0
  

  //This code block was to check if the current window is empty ie "desktop"
  //if yes then turn state from collapsed to expanded
  //but since active state for my bar is rest for all windows so i have commented it
  //onActWinNameChanged: {
  //  if (reservedShell) {
  //    return;
  //  }
  //  if (root.actWinName == "desktop" && root.notchState == "COLLAPSED") {
  //    root.notchState = "EXPANDED";
  //  } else if (root.notchState == "EXPANDED" && !root.notchHovered) {
  //    root.notchState = "COLLAPSED";
  //  }
  //}
}
