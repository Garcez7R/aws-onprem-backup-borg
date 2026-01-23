# Projeto: Backup Híbrido AWS → VM Debian 13 (BorgBackup)

Este projeto implementa uma solução de backup seguro e eficiente utilizando **BorgBackup**, transferindo dados de uma instância EC2 na AWS para uma VM local (On-Premises ou Cloud externa) rodando Debian 13.

## 🏗️ Arquitetura

- **Origem (Cliente):** AWS EC2 (Amazon Linux/Ubuntu).
- **Destino (Servidor):** VM Debian 13.
- **Protocolo:** SSH com restrição de comandos para máxima segurança.
- **Ferramenta:** BorgBackup (Deduplicação, Compressão e Criptografia).

## 📂 Estrutura do Repositório

- `scripts/`: Scripts de automação para instalação e execução.
- `docs/`: Documentação detalhada e evidências.
- `config/`: Exemplos de arquivos de configuração.

## 🚀 Como Usar

### 1. Preparação do Servidor (VM Debian 13)
No servidor de destino, execute o script de configuração:
```bash
chmod +x scripts/setup_server.sh
./scripts/setup_server.sh
```

### 2. Preparação do Cliente (AWS EC2)
Na instância EC2, instale o Borg:
```bash
chmod +x scripts/install_borg.sh
./scripts/install_borg.sh
```

### 3. Configuração de Acesso SSH
Gere uma chave SSH na EC2 e adicione a chave pública no servidor de destino (`/home/backup/.ssh/authorized_keys`) com a restrição:
```text
command="borg serve",restrict ssh-ed25519 AAAA...
```

### 4. Execução do Backup
Edite as variáveis no arquivo `scripts/run_backup.sh` e execute:
```bash
chmod +x scripts/run_backup.sh
./scripts/run_backup.sh
```

## 🔒 Segurança
- **Criptografia:** Repositório inicializado com `repokey-blake2`.
- **SSH Restrito:** O usuário de backup não possui acesso ao shell, apenas ao binário do Borg.
- **Deduplicação:** Apenas blocos de dados alterados são transferidos, economizando largura de banda e espaço.

## 🛠️ Comandos Úteis
- **Listar backups:** `borg list usuario@ip:/caminho/repo`
- **Restaurar arquivo:** `borg extract usuario@ip:/caminho/repo::nome-backup caminho/do/arquivo`
- **Verificar integridade:** `borg check usuario@ip:/caminho/repo`

---
*Projeto gerado para fins de portfólio e laboratório técnico.*
