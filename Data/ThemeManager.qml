pragma Singleton
import QtQuick
import QtCore

Item {
    id: themeManager
    
    // Set application identifiers at the very beginning
    // don't know why they are needed but not having them gives a warning which botheres me but it should work fine without this
    property bool _initialized: {
        Qt.application.organization = "kurukurubar"
        Qt.application.domain = "kurubar.app"
        Qt.application.name = "Kurubar"
        return true
    }
    
    // Available themes add theme here after adding there js file in themes dir
    // Also add an alias as theme can be too big for the small current theme section and uncommetnt the alias block below if you use them
    readonly property var themes: [
        { name: "Everforest", file: "Everforest.js" },
        { name: "Kanagawa Red", file: "KanagawaRed.js" },
        { name: "Kanagawa", file: "Kanagawa.js" },
        { name: "Gruvbox", file: "Gruvbox.js" },
        { name: "Graphite", file: "Graphitemono.js" },
        { name: "Mauve", file: "Mauve.js" },
        { name: "Rosepine", file: "Rosepine.js" },
        { name: "Catppucin", file: "Catppuccin.js" },
        { name: "Oxocarbon", file: "Oxocarbon.js" },
        { name: "Magic Girl", file: "MagicGirl.js" },  //op's
        { name: "Sakura Dark", file: "SakuraDark.js" },
        { name: "Sakura", file: "Sakura.js" },
        { name: "Kanagawa Light", file: "KanagawaLight.js" },
        { name: "Light", file: "Light.js" }, //op's
        //Comment out the theme you don't use to make the selection screen less cluttered
    ]
    
    // Current theme index - will be persisted
    property int currentThemeIndex: 0  // Default fallback
    
    // Current theme object
    property var currentTheme: null
    
    // Signal emitted when theme changes
    signal themeChanged()
    
    // Settings for persistence(remember current theme)
    Settings {
        id: settings
        property alias savedThemeIndex: themeManager.currentThemeIndex
    }
    
    Component.onCompleted: {
        // Load the saved theme or default
        console.log("Loading saved theme: ", themes[currentThemeIndex].name)
        loadTheme(currentThemeIndex)
    }
    
    function loadTheme(index) {
        if (index < 0 || index >= themes.length) {
            console.warn("Invalid theme index:", index)
            return false
        }
        
        const themeName = themes[index].file
        console.log("Attempting to load theme:", themes[index].name, "from file:", themeName)
        
        try {
            // Dynamic import of theme
            const component = Qt.createQmlObject(`
                import QtQuick
                import "../Themes/${themeName}" as ThemeImport
                QtObject {
                    readonly property var theme: ThemeImport.theme
                }
            `, themeManager, "DynamicTheme")
            
            if (component && component.theme) {
                // Only update index after successful loading
                currentThemeIndex = index
                currentTheme = component.theme
                themeChanged()
                console.log("Theme loaded successfully:", themes[index].name)
                return true
            } else {
                console.error("Failed to load theme - component or theme is null:", themeName)
                return false
            }
        } catch (error) {
            console.error("Error loading theme:", themeName, "Error:", error.toString())
            return false
        }
    }
    
    function switchToTheme(index) {
        if (index === currentThemeIndex) {
            return true
        }
        
        const success = loadTheme(index)
        if (success) {
            // Save the theme preference automatically via Settings
            console.log("Theme switched and saved:", themes[index].name)
        } else {
            console.warn("Failed to switch to theme:", themes[index].name)
        }
        return success
    }
    
    function switchToThemeByName(name) {
        for (let i = 0; i < themes.length; i++) {
            if (themes[i].name === name) {
                return switchToTheme(i)
            }
        }
        console.warn("Theme not found:", name)
        return false
    }
    
    function getThemeName() {
        if (currentThemeIndex >= 0 && currentThemeIndex < themes.length) {
            return themes[currentThemeIndex].name
        }
        return "Unknown"
    }
    //If you want to use aliases for different theme to dispalay in the homeview than you can uncomment this 
    //And add aliases in the array above, I have not used them
    //function getThemeAlias() {

    //    if (currentThemeIndex >= 0 && currentThemeIndex < themes.length) {
    //        return themes[currentThemeIndex].alias
    //    }
    //    return "unknown"
    //}

}
