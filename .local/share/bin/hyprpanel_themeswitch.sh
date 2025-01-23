#!/bin/bash

# Define os temas
themes=(
    "catppuccin_macchiato"
    "catppuccin_mocha"
    "cyberpunk"
    "dracula"
    "everforest"
    "gruvbox"
    "monochrome"
    "nord"
    "one_dark"
    "rose_pine"
    "rose_pine_moon"
    "tokyo_night"
)

# Define os tipos
types=(
    "normal"
    "split"
    "vivid"
)

# 
ROFI_STYLE="/home/paule/.config/rofi/styles/style_10.rasi"

# Caminho para os temas
themes_path="/usr/share/hyprpanel/themes/"

# Use rofi para selecionar o tipo
selected_type=$(printf "%s\n" "${types[@]}" | rofi -dmenu -theme "$ROFI_STYLE" -p "Select Type:")

# Use rofi para selecionar o tema
selected_theme=$(printf "%s\n" "${themes[@]}" | rofi -dmenu -theme "$ROFI_STYLE" -p "Select Theme:")

# Constrói o nome do arquivo do tema
if [ "$selected_type" == "normal" ]; then
    theme_file="${selected_theme}.json"
else
    theme_file="${selected_theme}_${selected_type}.json"
fi

# Caminho completo do tema
theme_path="${themes_path}${theme_file}"

# Verifica se o arquivo existe
if [ -f "$theme_path" ]; then
    hyprpanel useTheme "$theme_path"
    notify-send "Theme Applied" "$theme_path"

elif [ "$theme_file" == "_.json" ]; then
    notify-send "Error" "No theme selected"
else
    notify-send "Error" "Theme file not found: $theme_path"
fi