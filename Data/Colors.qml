pragma Singleton
import Quickshell
import QtQuick
import "../Data/" as Dat

Singleton {
  // To use ThemeManager instead of direct import
  readonly property color background: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.background : "#000000"
  readonly property color error: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.error : "#ff0000"
  readonly property color error_container: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.error_container : "#ff0000"
  readonly property color inverse_on_surface: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.inverse_on_surface : "#ffffff"
  readonly property color inverse_primary: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.inverse_primary : "#ffffff"
  readonly property color inverse_surface: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.inverse_surface : "#000000"
  readonly property color on_background: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_background : "#ffffff"
  readonly property color on_error: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_error : "#ffffff"
  readonly property color on_error_container: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_error_container : "#ffffff"
  readonly property color on_primary: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_primary : "#ffffff"
  readonly property color on_primary_container: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_primary_container : "#ffffff"
  readonly property color on_primary_fixed: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_primary_fixed : "#ffffff"
  readonly property color on_primary_fixed_variant: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_primary_fixed_variant : "#ffffff"
  readonly property color on_secondary: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_secondary : "#ffffff"
  readonly property color on_secondary_container: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_secondary_container : "#ffffff"
  readonly property color on_secondary_fixed: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_secondary_fixed : "#ffffff"
  readonly property color on_secondary_fixed_variant: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_secondary_fixed_variant : "#ffffff"
  readonly property color on_surface: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_surface : "#ffffff"
  readonly property color on_surface_variant: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_surface_variant : "#ffffff"
  readonly property color on_tertiary: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_tertiary : "#ffffff"
  readonly property color on_tertiary_container: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_tertiary_container : "#ffffff"
  readonly property color on_tertiary_fixed: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_tertiary_fixed : "#ffffff"
  readonly property color on_tertiary_fixed_variant: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.on_tertiary_fixed_variant : "#ffffff"
  readonly property color outline: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.outline : "#666666"
  readonly property color outline_variant: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.outline_variant : "#666666"
  readonly property color primary: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.primary : "#0066cc"
  readonly property color primary_container: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.primary_container : "#0066cc"
  readonly property color primary_fixed: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.primary_fixed : "#0066cc"
  readonly property color primary_fixed_dim: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.primary_fixed_dim : "#0066cc"
  readonly property color scrim: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.scrim : "#000000"
  readonly property color secondary: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.secondary : "#666666"
  readonly property color secondary_container: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.secondary_container : "#666666"
  readonly property color secondary_fixed: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.secondary_fixed : "#666666"
  readonly property color secondary_fixed_dim: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.secondary_fixed_dim : "#666666"
  readonly property color shadow: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.shadow : "#000000"
  readonly property color source_color: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.source_color : "#0066cc"
  readonly property color surface: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.surface : "#111111"
  readonly property color surface_bright: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.surface_bright : "#222222"
  readonly property color surface_container: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.surface_container : "#1a1a1a"
  readonly property color surface_container_high: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.surface_container_high : "#2a2a2a"
  readonly property color surface_container_highest: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.surface_container_highest : "#3a3a3a"
  readonly property color surface_container_low: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.surface_container_low : "#0a0a0a"
  readonly property color surface_container_lowest: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.surface_container_lowest : "#050505"
  readonly property color surface_dim: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.surface_dim : "#111111"
  readonly property color surface_tint: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.surface_tint : "#0066cc"
  readonly property color surface_variant: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.surface_variant : "#1a1a1a"
  readonly property color tertiary: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.tertiary : "#666666"
  readonly property color tertiary_container: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.tertiary_container : "#666666"
  readonly property color tertiary_fixed: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.tertiary_fixed : "#666666"
  readonly property color tertiary_fixed_dim: Dat.ThemeManager.currentTheme ? Dat.ThemeManager.currentTheme.tertiary_fixed_dim : "#666666"
  
  function withAlpha(color: color, alpha: real): color {
    return Qt.rgba(color.r, color.g, color.b, alpha);
  }
  
  // Connect to theme changes
  Connections {
    target: Dat.ThemeManager
    function onThemeChanged() {
      // This ensures all UI elements update when theme changes
    }
  }
}
