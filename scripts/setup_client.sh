#!/bin/bash
# Script para configurar o cliente (AWS EC2 Ubuntu 22.04) de forma rápida
set -e

echo "🚀 Iniciando configuração do cliente Ubuntu 22.04..."

# 1. Atualizar e instalar Borg
echo "📦 Instalando BorgBackup..."
sudo apt update && sudo apt install -y borgbackup

# 2. Gerar chave SSH se não existir
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    echo "🔑 Gerando chave SSH (ED25519)..."
    ssh-keygen -t ed25519 -N "" -f "$HOME/.ssh/id_ed25519"
else
    echo "🔑 Chave SSH já existe."
fi

echo "-------------------------------------------------------"
echo "✅ CLIENTE CONFIGURADO COM SUCESSO!"
echo ""
echo "Sua chave pública para adicionar no servidor é:"
cat "$HOME/.ssh/id_ed25519.pub"
echo ""
echo "Use o prefixo no servidor: command=\"borg serve\",restrict"
echo "-------------------------------------------------------"
