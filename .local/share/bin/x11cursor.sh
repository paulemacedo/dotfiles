#!/bin/bash

# Caminho do arquivo .Xresources
XRESOURCES="$HOME/.Xresources"

# Função para obter tema e tamanho do cursor via gsettings
get_gsettings_cursor_settings() {
    CURRENT_THEME=$(gsettings get org.gnome.desktop.interface cursor-theme | tr -d "'")
    CURRENT_SIZE=$(gsettings get org.gnome.desktop.interface cursor-size)

    # Define valores padrão se gsettings não retornar nada
    CURRENT_THEME=${CURRENT_THEME:-"Adwaita"}
    CURRENT_SIZE=${CURRENT_SIZE:-20}
}

# Atualizar .Xresources com o tema e tamanho
update_xresources() {
    {
        echo "Xcursor.theme: $1"
        echo "Xcursor.size: $2"
    } > "$XRESOURCES"

    # Aplica as mudanças com xrdb
    xrdb "$XRESOURCES"

    echo "Tema do cursor atualizado para: $1"
    echo "Tamanho do cursor atualizado para: $2"
}

# Detecta configurações atuais usando gsettings
get_gsettings_cursor_settings

# Verifica argumentos passados
if [ "$#" -eq 0 ]; then
    echo "Sem argumentos. Usando configurações detectadas pelo sistema:"
    echo "Tema: $CURRENT_THEME"
    echo "Tamanho: $CURRENT_SIZE"
    update_xresources "$CURRENT_THEME" "$CURRENT_SIZE"
elif [ "$#" -eq 2 ]; then
    NEW_THEME="$1"
    NEW_SIZE="$2"
    update_xresources "$NEW_THEME" "$NEW_SIZE"
else
    echo "Uso: $0 [<nome_do_tema> <tamanho_do_cursor>]"
    exit 1
fi
