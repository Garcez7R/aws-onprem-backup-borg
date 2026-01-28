#!/bin/bash
# setup_ec2.sh - Configuração do Cliente (AWS EC2 Ubuntu 22.04)
set -e

echo "🚀 [EC2] Iniciando configuração do Cliente..."

# 1. Instalação do Borg
sudo apt update && sudo apt install -y borgbackup

# 2. Criação de arquivos Dummy para teste (Zero Touch)
mkdir -p ~/borg_test_data
for i in {1..5}; do
    dd if=/dev/urandom of=~/borg_test_data/file_$i.bin bs=1M count=$((i * 2)) 2>/dev/null
done

echo "✅ [EC2] Cliente configurado e arquivos Dummy criados!"
echo "📌 Lembre-se de adicionar a chave pública da VM em ~/.ssh/authorized_keys"
