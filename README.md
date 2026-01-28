# Backup Híbrido AWS (Ubuntu 22.04) → VM Local (BorgBackup)

Este projeto foi otimizado para ser a solução mais rápida e funcional de backup entre AWS EC2 (Ubuntu 22.04) e um servidor de destino.

## 🚀 Instalação Rápida

### 1. No Cliente (AWS EC2 Ubuntu 22.04)
Execute o comando abaixo para instalar o Borg e gerar sua chave SSH:
```bash
make install-client
```
*Copie a chave pública gerada ao final do script.*

### 2. No Servidor de Destino (VM Local)
Prepare o ambiente para receber os backups:
```bash
make setup-server
```
*Cole a chave do cliente em `/home/backup/.ssh/authorized_keys` com o prefixo `command="borg serve",restrict`.*

### 3. Inicializar o Repositório (Na EC2)
```bash
make init-repo
```

## 🛠️ Uso Diário

- **Executar Backup:** `make backup` (Inclui verificação de integridade e limpeza automática).
- **Ver Logs:** `make logs`.
- **Configurações:** Edite o arquivo `config/backup.env.example` (renomeie para `.env`) para definir IPs, senhas e Webhooks.

## 🔒 Diferenciais desta Versão
- **Foco em Ubuntu 22.04:** Maior compatibilidade e facilidade de pacotes.
- **Validação Automática:** Roda `borg check` após cada backup.
- **Limpeza (Pruning):** Mantém backups dos últimos 7 dias e 4 semanas automaticamente.
- **Segurança Máxima:** SSH restrito apenas para o serviço do Borg.

---
*Ajustado para máxima performance e simplicidade.*
