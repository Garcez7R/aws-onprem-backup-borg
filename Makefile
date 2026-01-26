# ==========================================
# Makefile - Automação Zero Touch
# Projeto: Backup Híbrido AWS -> On-Premise
# ==========================================

.PHONY: help install setup test-data backup logs clean

help:
	@echo "Comandos disponíveis:"
	@echo "  make install  - Instala o BorgBackup no sistema"
	@echo "  make setup    - Configura o servidor de destino (Debian)"
	@echo "  make test-data - Cria arquivos dummy para teste de backup"
	@echo "  make backup   - Executa o processo de backup completo"
	@echo "  make logs     - Visualiza os logs de backup em tempo real"
	@echo "  make clean    - Limpa arquivos temporários e logs antigos"

install:
	@echo "Iniciando instalação..."
	@chmod +x scripts/install_borg.sh
	@./scripts/install_borg.sh

setup:
	@echo "Configurando servidor..."
	@chmod +x scripts/setup_server.sh
	@./scripts/setup_server.sh

test-data:
	@echo "Criando dados de teste..."
	@chmod +x scripts/create_dummies.sh
	@./scripts/create_dummies.sh

backup:
	@echo "Iniciando backup..."
	@chmod +x scripts/run_backup.sh
	@sudo touch /var/log/borg_backup.log && sudo chmod 666 /var/log/borg_backup.log
	@./scripts/run_backup.sh

logs:
	@tail -f /var/log/borg_backup.log

clean:
	@echo "Limpando logs..."
	@sudo rm -f /var/log/borg_backup.log
	@echo "Limpeza concluída."
