# ==========================================
# Makefile - Projeto Backup Zero Touch
# ==========================================

.PHONY: help setup-vm setup-ec2 backup-now logs clean-logs

help:
	@echo "Comandos disponíveis:"
	@echo "  make setup-vm    - Executa na VM Local (Debian 13)"
	@echo "  make setup-ec2   - Executa na EC2 (Ubuntu 22.04)"
	@echo "  make backup-now  - Dispara o backup manualmente da VM"
	@echo "  make logs        - Visualiza os logs de backup"

setup-vm:
	@chmod +x scripts/setup_vm.sh
	@./scripts/setup_vm.sh

setup-ec2:
	@chmod +x scripts/setup_ec2.sh
	@./scripts/setup_ec2.sh

backup-now:
	@chmod +x scripts/run_backup_automated.sh
	@sudo touch /var/log/borg_backup.log && sudo chmod 666 /var/log/borg_backup.log
	@./scripts/run_backup_automated.sh

logs:
	@tail -f /var/log/borg_backup.log

clean-logs:
	@sudo rm -f /var/log/borg_backup.log
	@echo "Logs removidos."
