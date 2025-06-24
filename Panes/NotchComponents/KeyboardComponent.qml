// KeyboardComponent.qml
import QtQuick
import "../../Data" as Dat
import "../"

Item {
    id: root
    
    // Create instance of KeyBindings
    Dat.KeyBindings {
        id: keyBindingsHelper
    }
    
    ShowBindings {
        id: keypopup
    }
    
    property bool enabled: true
    property bool debugMode: false
    
    // Signals
    signal toggleNotch()
    signal collapseNotch()
    signal expandNotch()
    signal fullyexpandNotch()
    signal customShortcut(string shortcutName)
    signal toggleMusicPlayback()
    
    // Get keybindings from the helper - cache them for performance
    readonly property var keybindings: keyBindingsHelper.getKeyBindings(root)
    
    // Function to show keybindings popup
    function showKeyBindingsPopup() {
        keypopup.keybindings = keybindings;
        keypopup.open();
        customShortcut("show_Bindings");
    }
    
    Keys.onPressed: function(event) {
        if (!enabled) return;
        
        // Use the helper's handleKeyPress function
        if (keyBindingsHelper.handleKeyPress(event, root)) {
            // Key was handled, nothing more to do
            return;
        }
        
        // If you want to handle additional keys not in the helper
        // you can add them here
    }
    
    Component.onCompleted: {
        if (enabled) forceActiveFocus();
    }
    
    onEnabledChanged: {
        if (enabled) forceActiveFocus();
    }
}
