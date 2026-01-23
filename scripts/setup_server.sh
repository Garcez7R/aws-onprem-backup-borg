#!/bin/bash
# Script para configurar o servidor de destino (VM Debian 13)

set -e

REPO_PATH="/borg/repo"
BACKUP_USER="backup"

echo "Configurando servidor de backup..."

# 1. Criar usuário dedicado
if ! id "$BACKUP_USER" &>/dev/null; then
    echo "Criando usuário $BACKUP_USER..."
    sudo adduser --disabled-password --gecos "" "$BACKUP_USER"
else
    echo "Usuário $BACKUP_USER já existe."
fi

# 2. Criar diretório do repositório
echo "Configurando diretório do repositório em $REPO_PATH..."
sudo mkdir -p "$REPO_PATH"
sudo chown "$BACKUP_USER:$BACKUP_USER" /borg
sudo chmod 700 /borg

# 3. Inicializar repositório (se não existir)
if [ ! -d "$REPO_PATH/config" ]; then
    echo "Inicializando repositório Borg..."
    echo "AVISO: Você precisará definir uma senha para o repositório."
    sudo -u "$BACKUP_USER" borg init --encryption=repokey-blake2 "$REPO_PATH"
else
    echo "Repositório já inicializado."
fi

# 4. Configurar SSH restrito
echo "Configurando SSH restrito para o usuário $BACKUP_USER..."
sudo -u "$BACKUP_USER" mkdir -p "/home/$BACKUP_USER/.ssh"
sudo -u "$BACKUP_USER" touch "/home/$BACKUP_USER/.ssh/authorized_keys"
sudo chmod 700 "/home/$BACKUP_USER/.ssh"
sudo chmod 600 "/home/$BACKUP_USER/.ssh/authorized_keys"

echo "-------------------------------------------------------"
echo "SERVIDOR CONFIGURADO COM SUCESSO!"
echo "Próximos passos:"
echo "1. Adicione sua chave pública em /home/$BACKUP_USER/.ssh/authorized_keys"
echo "2. Use o prefixo: command=\"borg serve\",restrict <sua_chave_ssh>"
echo "-------------------------------------------------------"
