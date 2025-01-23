#!/bin/bash

# Get the active workspace information
workspace_info=$(hyprctl activeworkspace)

# Extract the monitor name
monitor=$(echo "$workspace_info" | grep 'on monitor' | awk '{print $4}')

# Start nwg-dock-hyprland on the active monitor
nwg-dock-hyprland -o "$monitor"