#!/bin/bash
# Script para facilitar o commit e push das alterações
set -e

echo "🚀 Preparando commit para o GitHub..."

# Adicionar todos os arquivos
git add .

# Criar mensagem de commit
COMMIT_MSG="feat: otimização para Ubuntu 22.04 e melhorias de automação"
git commit -m "$COMMIT_MSG"

echo "-------------------------------------------------------"
echo "✅ Alterações commitadas localmente!"
echo "Para subir para o GitHub, execute:"
echo "git push origin main"
echo "-------------------------------------------------------"
