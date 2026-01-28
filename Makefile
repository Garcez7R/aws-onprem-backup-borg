# ==========================================
# Makefile - Automação Otimizada (Ubuntu 22.04)
# ==========================================

.PHONY: help install-client setup-server backup logs clean init-repo

help:
	@echo "Comandos disponíveis:"
	@echo "  make install-client  - Configura a EC2 (Ubuntu 22.04)"
	@echo "  make setup-server    - Configura a VM de Destino"
	@echo "  make init-repo       - Inicializa o repositório Borg"
	@echo "  make backup          - Executa o backup com validação"
	@echo "  make logs            - Visualiza os logs"
	@echo "  make restore         - Restaura arquivos do backup"
	@echo "  make git-commit      - Prepara o commit das alterações"
	@echo "  make clean           - Limpa logs antigos"

install-client:
	@chmod +x scripts/setup_client.sh
	@./scripts/setup_client.sh

setup-server:
	@chmod +x scripts/setup_server.sh
	@./scripts/setup_server.sh

init-repo:
	@read -p "Digite o IP da VM: " IP; \
	read -p "Digite o caminho do repo [/borg/repo]: " REPO; \
	REPO=$${REPO:-/borg/repo}; \
	borg init --encryption=repokey-blake2 backup@$$IP:$$REPO

backup:
	@chmod +x scripts/run_backup.sh
	@sudo touch /var/log/borg_backup.log && sudo chmod 666 /var/log/borg_backup.log
	@./scripts/run_backup.sh

logs:
	@tail -f /var/log/borg_backup.log

restore:
	@chmod +x scripts/restore_backup.sh
	@./scripts/restore_backup.sh

git-commit:
	@chmod +x scripts/push_to_git.sh
	@./scripts/push_to_git.sh

clean:
	@sudo rm -f /var/log/borg_backup.log
	@echo "Logs limpos."
