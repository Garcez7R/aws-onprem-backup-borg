#!/bin/bash
# Script para criar dados de teste (dummies) para validar o backup

set -e

TEST_DIR="$HOME/borg_test_data"

echo "Criando diretório de teste em $TEST_DIR..."
mkdir -p "$TEST_DIR"

echo "Gerando arquivos dummy..."

# Arquivo de texto simples
echo "Este é um arquivo de teste para o BorgBackup." > "$TEST_DIR/documento_texto.txt"

# Arquivo de log simulado
echo "[$(date)] LOG: Sistema iniciado com sucesso." > "$TEST_DIR/app_debug.log"
echo "[$(date)] ERROR: Falha simulada para teste de backup." >> "$TEST_DIR/app_debug.log"

# Arquivo binário de 1MB (simulando uma imagem ou binário)
dd if=/dev/urandom of="$TEST_DIR/imagem_fake.jpg" bs=1M count=1 status=none

# Arquivo de 5MB (simulando um banco de dados pequeno)
dd if=/dev/zero of="$TEST_DIR/banco_dados_fake.sql" bs=1M count=5 status=none

echo "-------------------------------------------------------"
echo "DADOS DE TESTE CRIADOS COM SUCESSO!"
ls -lh "$TEST_DIR"
echo "-------------------------------------------------------"
