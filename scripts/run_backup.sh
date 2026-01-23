#!/bin/bash
# Script para executar o backup da EC2 para o servidor de destino

# Configurações - ALTERE ESTES VALORES
REMOTE_USER="backup"
REMOTE_HOST="IP_DA_SUA_VM"
REMOTE_REPO="/borg/repo"
PASSPHRASE="SUA_SENHA_AQUI"

# Exportar a senha para o Borg não pedir interativamente
export BORG_PASSPHRASE="$PASSPHRASE"

REPOSITORY="$REMOTE_USER@$REMOTE_HOST:$REMOTE_REPO"
ARCHIVE="ec2-lab-$(date +%Y-%m-%d-%H%M%S)"

echo "Iniciando backup para $REPOSITORY..."

# Criar o backup
borg create --stats --progress \
    "$REPOSITORY::$ARCHIVE" \
    /etc \
    /var/www \
    /opt \
    --exclude '/etc/shadow' \
    --exclude '/etc/gshadow'

echo "Backup concluído: $ARCHIVE"

# Listar backups atuais
echo "Listagem de backups no repositório:"
borg list "$REPOSITORY"

# Limpeza (Prune) - Mantém 7 diários, 4 semanais e 6 mensais
echo "Executando limpeza de backups antigos (Prune)..."
borg prune -v --list --keep-daily=7 --keep-weekly=4 --keep-monthly=6 "$REPOSITORY"
