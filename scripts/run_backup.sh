#!/bin/bash
# ==============================================================================
# SCRIPT DE BACKUP OTIMIZADO - UBUNTU 22.04
# ==============================================================================

# Carregar variáveis de ambiente se o arquivo existir
if [ -f "../config/backup.env" ]; then
    source "../config/backup.env"
fi

# --- CONFIGURAÇÕES PADRÃO (Edite no config/backup.env) ---
REMOTE_USER="${REMOTE_USER:-backup}"
REMOTE_HOST="${REMOTE_HOST:-IP_DA_SUA_VM}"
REMOTE_REPO="${REMOTE_REPO:-/borg/repo}"
export BORG_PASSPHRASE="${BORG_PASSPHRASE:-SUA_SENHA_AQUI}"
LOG_FILE="${LOG_FILE:-/var/log/borg_backup.log}"
WEBHOOK_URL="${WEBHOOK_URL:-}"

REPOSITORY="$REMOTE_USER@$REMOTE_HOST:$REMOTE_REPO"
ARCHIVE="backup-$(hostname)-$(date +%Y-%m-%d-%H%M%S)"

send_notification() {
    local status=$1
    local message=$2
    local color=$3
    if [ -n "$WEBHOOK_URL" ]; then
        curl -H "Content-Type: application/json" -X POST \
             -d "{\"embeds\": [{\"title\": \"Backup $status - $(hostname)\", \"description\": \"$message\", \"color\": $color}]}" \
             "$WEBHOOK_URL"
    fi
}

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🚀 Iniciando backup..." | tee -a "$LOG_FILE"

# 1. Criar Backup
if borg create --stats --compression lz4 "$REPOSITORY::$ARCHIVE" \
    /etc /var/www /home/ubuntu \
    --exclude '*.tmp' --exclude '.cache' >> "$LOG_FILE" 2>&1; then
    
    MSG="✅ Backup OK: $ARCHIVE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $MSG" | tee -a "$LOG_FILE"
    
    # 2. Prune (Limpeza)
    echo "🧹 Limpando backups antigos..." >> "$LOG_FILE"
    borg prune -v --list --keep-daily=7 --keep-weekly=4 "$REPOSITORY" >> "$LOG_FILE" 2>&1
    
    # 3. Check (Validação de Integridade)
    echo "🔍 Validando repositório..." >> "$LOG_FILE"
    borg check "$REPOSITORY" >> "$LOG_FILE" 2>&1
    
    send_notification "SUCESSO" "$MSG" 65280
else
    MSG="❌ ERRO CRÍTICO no backup de $(hostname). Verifique $LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $MSG" | tee -a "$LOG_FILE"
    send_notification "ERRO" "$MSG" 16711680
    exit 1
fi
