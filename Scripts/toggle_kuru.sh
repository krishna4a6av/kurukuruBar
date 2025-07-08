#!/bin/bash
#script to check if kurubar is running if yes then kill it and if no the start it
#you can bind it to you preffered keyboard shortcuts in your hyprland config
#make sure that the BAR_PATH is below is pointing to your shell.qml correctly


BAR_PROC_NAME="quickshell"  # or the actual name of your bar process
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BAR_PATH="$SCRIPT_DIR/../shell.qml"

# Check if the bar is running
if pgrep -f "$BAR_PATH" > /dev/null; then
    echo "Bar is running. Killing it..."
    killall qs
else
    echo "Bar is not running. Starting it..."
    qs -p "$BAR_PATH" &
fi

