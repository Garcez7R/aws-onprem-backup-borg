#!/bin/bash
# run_backup_automated.sh - Script de Pull Backup (VM -> EC2)
set -e

# Carregar configurações
CONFIG_FILE="$(dirname "$0")/../config/backup.env"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Erro: Arquivo de configuração não encontrado em $CONFIG_FILE"
    exit 1
fi
source "$CONFIG_FILE"

LOG_FILE="/var/log/borg_backup.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$TIMESTAMP] 🚀 Iniciando Pull Backup da EC2 ($REMOTE_EC2_IP)..." | sudo tee -a $LOG_FILE

# Comando Borg Create (via SSH)
# O Borg na VM local se conecta na EC2 para ler os dados
ARCHIVE="ec2-backup-$(date +%Y-%m-%d-%H%M%S)"

if sudo -u backup borg create --stats --compression lz4 \
    "$REPO_PATH::$ARCHIVE" \
    "ssh://$REMOTE_EC2_USER@$REMOTE_EC2_IP/./" \
    --paths-from-text <(echo "$TARGET_DIRECTORIES" | tr ' ' '\n') >> $LOG_FILE 2>&1; then
    
    echo "[$TIMESTAMP] ✅ Backup concluído com sucesso: $ARCHIVE" | sudo tee -a $LOG_FILE
    
    # Pruning (Limpeza)
    sudo -u backup borg prune -v --list --keep-daily=7 --keep-weekly=4 "$REPO_PATH" >> $LOG_FILE 2>&1
    
    # Check (Validação)
    sudo -u backup borg check "$REPO_PATH" >> $LOG_FILE 2>&1
else
    echo "[$TIMESTAMP] ❌ FALHA no backup. Verifique os logs." | sudo tee -a $LOG_FILE
    exit 1
fi
