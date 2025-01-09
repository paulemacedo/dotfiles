#!/bin/bash

# Criar diretório de montagem se não existir
mkdir -p /mnt/Shared/OneDrive

# Verificar se a montagem foi bem sucedida
if mountpoint -q /mnt/Shared/OneDrive; then
    notify-send "OneDrive montado" "Microsoft OneDrive foi montado com sucesso."
    
    # Limpar cache do bisync para evitar erros
    rm -rf ~/.cache/rclone/bisync/
    
    # Sincronizar o OneDrive com configurações otimizadas para persistência
    rclone bisync OneDrive:/ /mnt/Shared/OneDrive \
        --resync \
        --check-access \
        --verbose \
        --timeout 2h \
        --transfers 4 \
        --checkers 8 \
        --drive-chunk-size 128M \
        --retries 3 \
        --ignore-existing

    # Verificar se a sincronização foi bem sucedida
    if [ $? -eq 0 ]; then
        notify-send "Sincronização bem sucedida" "A sincronização do OneDrive foi concluída com sucesso."
    else
        notify-send "Erro de sincronização" "Falha ao sincronizar o OneDrive."
        exit 1
    fi
else
    notify-send "Erro" "Falha ao montar o OneDrive."
    exit 1
fi