pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Singleton {
  id: root

  property string actWinName: activeWindow?.activated ? activeWindow?.appId : "desktop"
  readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
  property string hostName: "KuruKuru"
  property var activeMusicPlayer: null
  property real mprisDotRotation: 0
  property bool notchHovered: false

  //psystray popup
  property var trayPopup: null


  // change by small scale at a time.
  property real notchScale: 1

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
  
  // This singnal for music player
  signal toggleMusicPlayback()
  signal previousTrack()
  signal nextTrack()


}
