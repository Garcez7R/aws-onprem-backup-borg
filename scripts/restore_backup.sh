#!/bin/bash
# Script para facilitar a restauração de arquivos do backup
set -e

if [ -f "../config/backup.env" ]; then
    source "../config/backup.env"
fi

REMOTE_USER="${REMOTE_USER:-backup}"
REMOTE_HOST="${REMOTE_HOST:-IP_DA_SUA_VM}"
REMOTE_REPO="${REMOTE_REPO:-/borg/repo}"
export BORG_PASSPHRASE="${BORG_PASSPHRASE:-SUA_SENHA_AQUI}"

REPOSITORY="$REMOTE_USER@$REMOTE_HOST:$REMOTE_REPO"

echo "📂 Listando backups disponíveis..."
borg list "$REPOSITORY"

echo ""
read -p "Digite o nome do backup que deseja restaurar: " ARCHIVE
read -p "Digite o caminho do arquivo/pasta para restaurar (ex: etc/hosts ou deixe vazio para tudo): " PATH_RESTORE

echo "🚀 Restaurando $ARCHIVE..."
borg extract --progress "$REPOSITORY::$ARCHIVE" $PATH_RESTORE

echo "✅ Restauração concluída no diretório atual."
