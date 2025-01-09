#!/bin/bash

# Criar o diretório de montagem se não existir
mkdir -p /home/paule/OneDrive

# Montar o OneDrive com configurações otimizadas para persistência
rclone mount OneDrive: /home/paule/OneDrive \
    --vfs-cache-mode writes \
    --vfs-cache-max-size 1G \
    --dir-cache-time 72h \
    --poll-interval 10s \
    --attr-timeout 1h \
    --vfs-read-chunk-size 128M \
    --vfs-read-chunk-size-limit 1G \
    --buffer-size 128M \
    --daemon

# Esperar um momento para garantir que a montagem foi bem sucedida
sleep 2

# Verificar se a montagem foi bem sucedida
if mountpoint -q /home/paule/OneDrive; then
    notify-send "OneDrive montado" "Microsoft OneDrive foi montado com sucesso."
else
    notify-send "Erro" "Falha ao montar o OneDrive."
fi

