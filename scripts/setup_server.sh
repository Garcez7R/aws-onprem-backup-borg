#!/bin/bash
# Script para configurar o servidor de destino (VM Ubuntu/Debian)
set -e

REPO_PATH="/borg/repo"
BACKUP_USER="backup"

echo "🛠️ Configurando servidor de backup..."

# 1. Criar usuário dedicado
if ! id "$BACKUP_USER" &>/dev/null; then
    echo "👤 Criando usuário $BACKUP_USER..."
    sudo adduser --disabled-password --gecos "" "$BACKUP_USER"
else
    echo "👤 Usuário $BACKUP_USER já existe."
fi

# 2. Criar diretório do repositório
echo "📁 Configurando diretório em $REPO_PATH..."
sudo mkdir -p "$REPO_PATH"
sudo chown -R "$BACKUP_USER:$BACKUP_USER" /borg
sudo chmod 700 /borg

# 3. Configurar SSH restrito
echo "🔒 Configurando SSH restrito..."
sudo -u "$BACKUP_USER" mkdir -p "/home/$BACKUP_USER/.ssh"
sudo -u "$BACKUP_USER" touch "/home/$BACKUP_USER/.ssh/authorized_keys"
sudo chmod 700 "/home/$BACKUP_USER/.ssh"
sudo chmod 600 "/home/$BACKUP_USER/.ssh/authorized_keys"

echo "-------------------------------------------------------"
echo "✅ SERVIDOR PRONTO!"
echo "1. Adicione a chave pública do cliente em: /home/$BACKUP_USER/.ssh/authorized_keys"
echo "2. Use o formato: command=\"borg serve\",restrict ssh-ed25519 AAA..."
echo "-------------------------------------------------------"
