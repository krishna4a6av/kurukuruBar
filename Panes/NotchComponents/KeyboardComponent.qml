//KeyboardComponent
import QtQuick
import "../../Data/" as Dat
import "../../Widgets" as Wid

Item {
  id: root
  
  property bool enabled: true
  property bool debugMode: false
  
  // Signals for different shortcut actions
  signal toggleNotch()
  signal collapseNotch()
  signal expandNotch()
  signal fullyexpandNotch()
  signal customShortcut(string shortcutName)
  signal toggleMusicPlayback() 

  focus: enabled

  Keys.onPressed: function(event) {
    if (!enabled) return;

    // Debug logging
    if (debugMode) {
      console.log("Key pressed:", event.key, "Modifiers:", event.modifiers);
    }
    
    handleKeyPress(event);
  }
  
  function handleKeyPress(event) {
    const key = event.key;
    const modifiers = event.modifiers;
    const ctrl = modifiers & Qt.ControlModifier;
    const alt = modifiers & Qt.AltModifier;
    const shift = modifiers & Qt.ShiftModifier;
    //const meta = modifiers & Qt.MetaModifier; // Avoid windows key to avoid keybind overlaps
    
    // Space toggles between expanded and fullyexpanded
    // Also in the player it toggles playing, as it is muscle reflex for me and i assume a lot other peopel
    if (key === Qt.Key_Space) {
      event.accepted = true;
      
      // If we're fully expanded and on music view (index 3), handle play/pause
      if (Dat.Globals.notchState === "FULLY_EXPANDED" && Dat.Globals.swipeIndex === 3) {
        Dat.Globals.toggleMusicPlayback(); 
        customShortcut("music_toggle_play");
        return;
      }
      
      // Handle notch state changes for other cases
      if (Dat.Globals.notchState !== "FULLY_EXPANDED" && Dat.Globals.notchState !== "COLLAPSED") {
        Dat.Globals.notchState = "FULLY_EXPANDED";
        fullyexpandNotch();
      } else if (Dat.Globals.notchState === "COLLAPSED") {
        Dat.Globals.notchState = "EXPANDED";
        expandNotch();
      } else {
        Dat.Globals.notchState = "EXPANDED";
        expandNotch();
      }
      
      toggleNotch();
      return;
    }
        
    // Escape - Brings to EXPANDED from any state
    if (key === Qt.Key_Escape) {
      event.accepted = true;
      Dat.Globals.notchState = "EXPANDED";
      return;
    }
    
    // C - Collapses the bar not matter the state
    if (key === Qt.Key_C) {
      event.accepted = true;
      if (Dat.Globals.notchState === "COLLAPSED") {
        Dat.Globals.notchState = "EXPANDED";
        expandNotch();
      } else if (Dat.Globals.notchState === "EXPANDED") {
        Dat.Globals.notchState = "COLLAPSED";
        collapseNotch();
      } else {
        // If FULLY_EXPANDED, go to EXPANDED
        Dat.Globals.notchState = "COLLAPSED";
        expandNotch();
      }
      toggleNotch();
      return;
    }

    // Up Arrow/ Left Arrow- previous widget
    if (key === Qt.Key_Up || key === Qt.Key_Left) {
      event.accepted = true;
      if (Dat.Globals.swipeIndex > 0) {
        if (Dat.Globals.swipeIndex == 4 && Dat.Globals.settingsTabIndex > 0){
          Dat.Globals.settingsTabIndex--;
        }else{
          Dat.Globals.swipeIndex--;
        }
        customShortcut("navigate_up");
      }
      return;
    }
    
    // Down Arrow/Right Arrow - Next widget
    if (key === Qt.Key_Down || key === Qt.Key_Right) {
      event.accepted = true;
      if (Dat.Globals.swipeIndex <= 4) {
        if (Dat.Globals.swipeIndex < 4 ){
          Dat.Globals.swipeIndex++;
        }else if (Dat.Globals.settingsTabIndex < 2){
          Dat.Globals.settingsTabIndex++;
        }
        customShortcut("navigate_down");
      }
      return;
    }

    if (alt && key === Qt.Key_J) {
      event.accepted = true;
      Dat.Globals.previousTrack();
      customShortcut("music_previous");
      return;
    }

    if (alt && key === Qt.Key_K) {
      event.accepted = true;
      Dat.Globals.toggleMusicPlayback();
      customShortcut("music_toggle_play");
      return;
    }

    if (alt && key === Qt.Key_L) {
      event.accepted = true;
      Dat.Globals.nextTrack();
      customShortcut("music_next");
      return;
    }

  }

  Component.onCompleted: {
    if (debugMode) {
      console.log("KeyboardComponent initialized");
    }
    
    // Request focus when component is ready
    if (enabled) {
      forceActiveFocus();
    }
  }
  
  // Watch for enabled state changes
  onEnabledChanged: {
    if (enabled) {
      forceActiveFocus();
    }
  }
  
  // Debug information display, only in debug mode. Toggle in the main notch file.
  Rectangle {
    visible: debugMode
    anchors.top: parent.top
    anchors.right: parent.right
    width: 200
    height: 60
    color: "black"
    opacity: 0.7
    radius: 4
    
    Text {
      anchors.centerIn: parent
      color: "white"
      font.pixelSize: 10
      text: "Keyboard: " + (root.focus ? "Active" : "Inactive") + 
            "\nEnabled: " + root.enabled +
            "\nState: " + Dat.Globals.notchState
    }
  }
}
