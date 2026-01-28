#!/bin/bash
# Script para instalar o BorgBackup - Otimizado para Ubuntu 22.04
set -e

echo "📦 Instalando BorgBackup..."
if [ -f /etc/debian_version ]; then
    sudo apt update && sudo apt install -y borgbackup
else
    # Fallback para outros sistemas se necessário
    sudo yum install -y borgbackup || sudo dnf install -y borgbackup || echo "Por favor, instale o borgbackup manualmente."
fi

echo "✅ BorgBackup instalado: $(borg --version)"
