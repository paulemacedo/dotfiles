#!/bin/bash

ROFI_STYLE="$HOME/.config/rofi/styles/style_10.rasi"
HYPRDOCK_CMD="nwg-dock-hyprland -i 35 -mb 5 -mt 5"
CONFIG_FILE="$HOME/.config/nwg-dock-hyprland/config"
SCRIPT_PATH="$HOME/.local/share/bin/hyprdock.sh"

function save_config {
    echo "$1:$2:$3:$4" > "$CONFIG_FILE"
}

function load_config {
    if [ -f "$CONFIG_FILE" ]; then
        cat "$CONFIG_FILE"
    else
        echo "no-autohide:no-fullscreen:NULL:no-exclusive"
    fi
}

function show_rofi_menu {
    CURRENT_CONFIG=$(load_config)
    AUTOHIDE=$(echo "$CURRENT_CONFIG" | cut -d':' -f1)
    FULLSCREEN=$(echo "$CURRENT_CONFIG" | cut -d':' -f2)
    MONITOR=$(echo "$CURRENT_CONFIG" | cut -d':' -f3)
    EXCLUSIVE=$(echo "$CURRENT_CONFIG" | cut -d':' -f4)
    
    if [ "$AUTOHIDE" == "autohide" ]; then
        AUTOHIDE_STATUS="autohide ✓"
    else
        AUTOHIDE_STATUS="autohide メ"
    fi
    
    if [ "$FULLSCREEN" == "fullscreen" ]; then
        FULLSCREEN_STATUS="fullscreen ✓"
    else
        FULLSCREEN_STATUS="fullscreen メ"
    fi

    if [ "$EXCLUSIVE" == "exclusive" ]; then
        EXCLUSIVE_STATUS="exclusive zone ✓"
    else
        EXCLUSIVE_STATUS="exclusive zone メ"
    fi
    
    echo -e "Toggle Options:\n──────────────────────────────────────────\n$AUTOHIDE_STATUS\n$FULLSCREEN_STATUS\n$EXCLUSIVE_STATUS\n──────────────────────────────────────────\nChoose Monitor:\nNone\nDP-2\nHDMI-A-1" | rofi -dmenu -theme "$ROFI_STYLE" -p "Select Option:"
}

function toggle_option {
    CURRENT_CONFIG=$(load_config)
    AUTOHIDE=$(echo "$CURRENT_CONFIG" | cut -d':' -f1)
    FULLSCREEN=$(echo "$CURRENT_CONFIG" | cut -d':' -f2)
    MONITOR=$(echo "$CURRENT_CONFIG" | cut -d':' -f3)
    EXCLUSIVE=$(echo "$CURRENT_CONFIG" | cut -d':' -f4)
    
    case "$1" in
        "autohide")
            if [ "$AUTOHIDE" == "autohide" ]; then
                AUTOHIDE="no-autohide"
            else
                AUTOHIDE="autohide"
            fi
            ;;
        "fullscreen")
            if [ "$FULLSCREEN" == "fullscreen" ]; then
                FULLSCREEN="no-fullscreen"
            else
                FULLSCREEN="fullscreen"
            fi
            ;;
        "exclusive")
            if [ "$EXCLUSIVE" == "exclusive" ]; then
                EXCLUSIVE="no-exclusive"
            else
                EXCLUSIVE="exclusive"
            fi
            ;;
    esac
    
    save_config "$AUTOHIDE" "$FULLSCREEN" "$MONITOR" "$EXCLUSIVE"
}

function set_monitor {
    CURRENT_CONFIG=$(load_config)
    AUTOHIDE=$(echo "$CURRENT_CONFIG" | cut -d':' -f1)
    FULLSCREEN=$(echo "$CURRENT_CONFIG" | cut -d':' -f2)
    EXCLUSIVE=$(echo "$CURRENT_CONFIG" | cut -d':' -f4)
    
    if [ "$1" == "None" ]; then
        save_config "$AUTOHIDE" "$FULLSCREEN" "NULL" "$EXCLUSIVE"
    else
        save_config "$AUTOHIDE" "$FULLSCREEN" "$1" "$EXCLUSIVE"
    fi
}

if [ "$1" == "-m" ]; then
    SELECTED_OPTION=$(show_rofi_menu)
    
    case "$SELECTED_OPTION" in
        "autohide メ"|"autohide ✓")
            toggle_option "autohide"
            $SCRIPT_PATH -m
            ;;
        "fullscreen メ"|"fullscreen ✓")
            toggle_option "fullscreen"
            $SCRIPT_PATH -m
            ;;
        "exclusive zone メ"|"exclusive zone ✓")
            toggle_option "exclusive"
            $SCRIPT_PATH -m
            ;;
        "Choose Monitor:"|"──────────────────────────────────────────" | "Toggle Options:")
            $SCRIPT_PATH -m
            ;;
        "None"|"DP-2"|"HDMI-A-1")
            set_monitor "$SELECTED_OPTION"
            $SCRIPT_PATH -m
            ;;
    esac
elif [ "$1" == "-t" ]; then
    workspace_info=$(hyprctl activeworkspace)
    activemonitor=$(echo "$workspace_info" | grep 'on monitor' | awk -F 'on monitor ' '{print $2}' | awk '{print $1}' | sed 's/://')
    nwg-dock-hyprland -o "$activemonitor"
    notify-send "Hyprdock toggled to $activemonitor"
else
    CURRENT_CONFIG=$(load_config)
    AUTOHIDE=$(echo "$CURRENT_CONFIG" | cut -d':' -f1)
    FULLSCREEN=$(echo "$CURRENT_CONFIG" | cut -d':' -f2)
    MONITOR=$(echo "$CURRENT_CONFIG" | cut -d':' -f3)
    EXCLUSIVE=$(echo "$CURRENT_CONFIG" | cut -d':' -f4)
    
    CMD="$HYPRDOCK_CMD"
    
    if [ "$AUTOHIDE" == "autohide" ]; then
        CMD+=" -d"
    fi
    
    if [ "$FULLSCREEN" == "fullscreen" ]; then
        CMD+=" -f"
    fi

    if [ "$EXCLUSIVE" == "exclusive" ]; then
        CMD+=" -x"
    fi

    if [ "$MONITOR" != "NULL" ]; then
        CMD+=" -o $MONITOR"
    fi
    
    $CMD

    if [ "$MONITOR" == "NULL" ]; then
        notify-send "Hyprdock started on active monitor"
    else 
        notify-send "Hyprdock started on $MONITOR"
    fi
fi