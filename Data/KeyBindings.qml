import QtQuick
import "../Data" as Dat

QtObject {
    id: keyBindings

    // Function to get all keybindings - takes the component as parameter for signal access
    function getKeyBindings(component) {
        return [
            { key: Qt.Key_Space, alt: false, label: "Toggle Notch", action: function() {
                if (Dat.Globals.notchState !== "FULLY_EXPANDED" && Dat.Globals.notchState !== "COLLAPSED") {
                    Dat.Globals.notchState = "FULLY_EXPANDED";
                    if (component.fullyexpandNotch) component.fullyexpandNotch();
                } else if (Dat.Globals.notchState === "COLLAPSED") {
                    Dat.Globals.notchState = "EXPANDED";
                    if (component.expandNotch) component.expandNotch();
                } else {
                    Dat.Globals.notchState = "EXPANDED";
                    if (component.expandNotch) component.expandNotch();
                }
                if (component.toggleNotch) component.toggleNotch();
            }},
            { key: Qt.Key_Escape, alt: false, label: "Exit fullyexpaded state", action: function() {
                if (Dat.Globals.notchState === "FULLY_EXPANDED"){
                    Dat.Globals.notchState = "EXPANDED";
                }
            }},
            { key: Qt.Key_C, alt: false, label: "Toggle Collapse", action: function() {
                if (Dat.Globals.notchState === "COLLAPSED") {
                    Dat.Globals.notchState = "EXPANDED";
                    if (component.expandNotch) component.expandNotch();
                } else {
                    Dat.Globals.notchState = "COLLAPSED";
                    if (component.collapseNotch) component.collapseNotch();
                }
                if (component.toggleNotch) component.toggleNotch();
            }},
            { key: Qt.Key_Left, alt: false, label: "Navigate Left/Up", action: function() {
                if (Dat.Globals.swipeIndex > 0) {
                    if (Dat.Globals.swipeIndex == 4 && Dat.Globals.settingsTabIndex > 0) {
                        Dat.Globals.settingsTabIndex--;
                    } else {
                        Dat.Globals.swipeIndex--;
                    }
                    if (component.customShortcut) component.customShortcut("navigate_up");
                }
            }},
            { key: Qt.Key_Up, alt: false, label: "Navigate Left/Up", action: function() {
                if (Dat.Globals.swipeIndex > 0) {
                    if (Dat.Globals.swipeIndex == 4 && Dat.Globals.settingsTabIndex > 0) {
                        Dat.Globals.settingsTabIndex--;
                    } else {
                        Dat.Globals.swipeIndex--;
                    }
                    if (component.customShortcut) component.customShortcut("navigate_up");
                }
            }},
            { key: Qt.Key_Right, alt: false, label: "Navigate Right/Down", action: function() {
                if (Dat.Globals.swipeIndex <= 4) {
                    if (Dat.Globals.swipeIndex < 4) {
                        Dat.Globals.swipeIndex++;
                    } else if (Dat.Globals.settingsTabIndex < 2) {
                        Dat.Globals.settingsTabIndex++;
                    }
                    if (component.customShortcut) component.customShortcut("navigate_down");
                }
            }},
            { key: Qt.Key_Down, alt: false, label: "Navigate Right/Down", action: function() {
                if (Dat.Globals.swipeIndex <= 4) {
                    if (Dat.Globals.swipeIndex < 4) {
                        Dat.Globals.swipeIndex++;
                    } else if (Dat.Globals.settingsTabIndex < 2) {
                        Dat.Globals.settingsTabIndex++;
                    }
                    if (component.customShortcut) component.customShortcut("navigate_down");
                }
            }},
            { key: Qt.Key_T, alt: true, shift:false, label: "Next Theme", action: function() {
                const tm = Dat.ThemeManager;
                const nextIndex = (tm.currentThemeIndex + 1) % tm.themes.length;
                tm.switchToTheme(nextIndex);
                if (component.customShortcut) component.customShortcut("switch_theme_next");
            }},
            { key: Qt.Key_T, alt: true, shift:true, label: "Previous Theme", action: function() {
                const tm = Dat.ThemeManager;
                const prevIndex = (tm.currentThemeIndex - 1 + tm.themes.length) % tm.themes.length;
                tm.switchToTheme(prevIndex);
                if (component.customShortcut) component.customShortcut("switch_theme_prev");
            }},
            { key: Qt.Key_Left, alt: true, label: "Music Previous", action: function() {
                Dat.Globals.previousTrack();
                if (component.customShortcut) component.customShortcut("music_previous");
            }},
            { key: Qt.Key_Space, alt: true, label: "Music Play/Pause", action: function() {
                Dat.Globals.toggleMusicPlayback();
                if (component.customShortcut) component.customShortcut("music_toggle_play");
            }},
            { key: Qt.Key_Right, alt: true, label: "Music Next", action: function() {
                Dat.Globals.nextTrack();
                if (component.customShortcut) component.customShortcut("music_next");
            }},
            { key: Qt.Key_D, alt: true, label: "Clear Notifications", action: function() {
                if (Dat.NotifServer && Dat.NotifServer.clearNotifs) {
                    Dat.NotifServer.clearNotifs();
                }
                if (component.customShortcut) component.customShortcut("clear_notifications");
            }},
            { key: Qt.Key_C, alt: true, label: "Toggle Idle", action: function() {
                if (Dat.SessionActions && Dat.SessionActions.toggleIdle) {
                    Dat.SessionActions.toggleIdle();
                }
                if (component.customShortcut) component.customShortcut("toggle_idle");
            }},
            { key: Qt.Key_N, alt: true, label: "Toggle Notifications", action: function() {
                if (Dat.NotifServer) {
                    Dat.NotifServer.dndEnabled = !Dat.NotifServer.dndEnabled;
                }
                if (component.customShortcut) component.customShortcut("toggle_notifications");
            }},
            { key: Qt.Key_Slash, alt: true, label: "Show Key Bindings", action: function() {
                if (component.showKeyBindingsPopup) {
                    component.showKeyBindingsPopup();
                } else if (component.customShortcut) {
                    component.customShortcut("show_bindings");
                }
            }}
        ];
    }

    //function to handle key press
    function handleKeyPress(event, component) {
        const bindings = getKeyBindings(component);
        for (let i = 0; i < bindings.length; i++) {
            const b = bindings[i];
            const altMatch = !!b.alt === !!(event.modifiers & Qt.AltModifier);
            const shiftMatch = b.shift === undefined || (!!b.shift === !!(event.modifiers & Qt.ShiftModifier));
            const keyMatch = b.key === event.key;
    
            if (keyMatch && altMatch && shiftMatch) {
                event.accepted = true;
                try {
                    b.action();
                } catch (error) {
                    console.warn("Error executing keybinding action:", error);
                }
                return true;
            }
        }
        return false;
    }
    
}
