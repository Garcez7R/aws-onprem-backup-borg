#!/bin/bash
# setup_vm.sh - Configuração do Servidor de Backup (Debian 13)
set -e

echo "🚀 [VM] Iniciando configuração do Servidor de Backup..."

# 1. Instalação de dependências
sudo apt update && sudo apt install -y borgbackup curl zip

# 2. Criação do usuário de backup (se não existir)
if ! id "backup" &>/dev/null; then
    sudo adduser --disabled-password --gecos "" backup
fi

# 3. Preparação do repositório
sudo mkdir -p /borg/repo
sudo chown -R backup:backup /borg
sudo chmod 700 /borg

# 4. Geração de chaves SSH para automação (se não existir)
if [ ! -f "/home/backup/.ssh/id_ed25519" ]; then
    sudo -u backup ssh-keygen -t ed25519 -N "" -f "/home/backup/.ssh/id_ed25519"
fi

echo "✅ [VM] Servidor configurado!"
echo "🔑 CHAVE PÚBLICA DA VM (Copie para a EC2):"
sudo cat /home/backup/.ssh/id_ed25519.pub
