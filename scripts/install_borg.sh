#!/bin/bash
# Script para instalar o BorgBackup em sistemas Debian/Ubuntu ou Amazon Linux

set -e

echo "Detectando sistema operacional..."
if [ -f /etc/debian_version ]; then
    echo "Sistema Debian/Ubuntu detectado."
    sudo apt update && sudo apt install -y borgbackup
elif [ -f /etc/system-release ]; then
    echo "Sistema baseado em RHEL/Amazon Linux detectado."
    sudo yum install -y borgbackup || sudo dnf install -y borgbackup
else
    echo "Sistema não suportado automaticamente. Tente instalar o pacote 'borgbackup' manualmente."
    exit 1
fi

echo "BorgBackup instalado com sucesso!"
borg --version
