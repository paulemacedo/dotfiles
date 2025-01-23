#!/bin/bash

workspace_info=$(hyprctl activeworkspace)
activemonitor=$(echo "$workspace_info" | grep 'on monitor' | awk -F 'on monitor ' '{print $2}' | awk '{print $1}' | sed 's/://')

notify-send "Active Monitor" "$activemonitor"