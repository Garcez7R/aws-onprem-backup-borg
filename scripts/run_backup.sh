#!/bin/bash

# ==============================================================================
# SCRIPT DE BACKUP HÍBRIDO COM LOGS E ALERTAS
# ==============================================================================

# --- CONFIGURAÇÕES DO BORG ---
REMOTE_USER="backup"
REMOTE_HOST="IP_DA_SUA_VM"
REMOTE_REPO="/borg/repo"
export BORG_PASSPHRASE="SUA_SENHA_AQUI"

# --- CONFIGURAÇÕES DE LOG E ALERTAS ---
LOG_FILE="/var/log/borg_backup.log"
WEBHOOK_URL="SUA_URL_DO_WEBHOOK_AQUI" # Discord ou Slack
HOSTNAME=$(hostname)

# --- FUNÇÃO DE NOTIFICAÇÃO ---
send_notification() {
    local status=$1
    local message=$2
    local color=$3 # 65280 (Verde) ou 16711680 (Vermelho) para Discord

    if [ "$WEBHOOK_URL" != "SUA_URL_DO_WEBHOOK_AQUI" ]; then
        curl -H "Content-Type: application/json" \
             -X POST \
             -d "{\"embeds\": [{\"title\": \"Backup $status - $HOSTNAME\", \"description\": \"$message\", \"color\": $color}]}" \
             $WEBHOOK_URL
    fi
}

# --- INÍCIO DO BACKUP ---
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando processo de backup..." | tee -a $LOG_FILE

REPOSITORY="$REMOTE_USER@$REMOTE_HOST:$REMOTE_REPO"
ARCHIVE="ec2-lab-$(date +%Y-%m-%d-%H%M%S)"

# Executa o backup e captura a saída
# Incluímos a pasta de dummies (~/borg_test_data) para validação imediata
if borg create --stats --progress "$REPOSITORY::$ARCHIVE" \
    "$HOME/borg_test_data" \
    /etc \
    --exclude '/etc/shadow' >> $LOG_FILE 2>&1; then
    MSG="✅ Backup realizado com sucesso em $REPOSITORY::$ARCHIVE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $MSG" | tee -a $LOG_FILE
    
    # Executa o Prune (Limpeza)
    borg prune -v --list --keep-daily=7 --keep-weekly=4 --keep-monthly=6 "$REPOSITORY" >> $LOG_FILE 2>&1
    
    send_notification "SUCESSO" "$MSG" 65280
else
    MSG="❌ FALHA CRÍTICA no backup de $HOSTNAME. Verifique os logs em $LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $MSG" | tee -a $LOG_FILE
    
    send_notification "ERRO" "$MSG" 16711680
    exit 1
fi
