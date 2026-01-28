# Projeto: Backup Híbrido AWS (Ubuntu 22.04) → VM Local (BorgBackup)

Este projeto implementa uma solução de backup seguro, eficiente e automatizado utilizando **BorgBackup**, transferindo dados de uma instância EC2 na AWS (otimizado para Ubuntu 22.04) para uma VM local (On-Premises ou Cloud externa) via SSH restrito.

## 🏗️ Arquitetura Otimizada

- **Origem (Cliente):** AWS EC2 rodando **Ubuntu 22.04 LTS**.
- **Destino (Servidor):** VM Local rodando Debian 13 ou Ubuntu 22.04.
- **Protocolo:** SSH com restrição de comandos (`borg serve`) para máxima segurança.
- **Ferramenta:** BorgBackup (Deduplicação, Compressão LZ4, Criptografia e Validação Automática).

## 📂 Estrutura do Repositório

- `scripts/`: Scripts de automação (Instalação, Setup, Backup, Restauração e Dummies).
- `docs/`: Documentação detalhada, guias de configuração e evidências.
- `config/`: Arquivos de configuração e variáveis de ambiente (`backup.env.example`).
- `Makefile`: O "Coração" do projeto. Automatiza todas as etapas com comandos simples.

## 🚀 Guia de Configuração (Passo a Passo)

### 1. Preparação do Cliente (AWS EC2 Ubuntu 22.04)
Na sua instância EC2, instale o Borg e gere as chaves necessárias:
```bash
make install-client
```
*Este comando instalará o Borg e gerará uma chave SSH ED25519. Copie a chave pública exibida no final.*

### 2. Preparação do Servidor (VM Local)
No servidor que receberá os dados, configure o usuário e diretórios:
```bash
make setup-server
```
**Configuração de Segurança SSH:**
Edite o arquivo `/home/backup/.ssh/authorized_keys` no servidor e adicione a chave do cliente com a restrição:
```text
command="borg serve",restrict ssh-ed25519 AAAA... (sua_chave_aqui)
```

### 3. Inicialização e Teste de Dados
De volta à EC2, crie arquivos de teste para validar a deduplicação e inicialize o repositório:
```bash
make test-data  # Cria ~/borg_test_data com arquivos de vários tamanhos
make init-repo  # Inicializa o repositório criptografado (digite o IP da VM quando solicitado)
```

### 4. Execução e Monitoramento
Para rodar o backup completo (incluindo validação de integridade e limpeza):
```bash
make backup
```
Para acompanhar os logs em tempo real:
```bash
make logs
```

## 🔒 Segurança e Resiliência
- **Criptografia:** Repositório inicializado com `repokey-blake2`.
- **SSH Restrito:** O usuário de backup não possui acesso ao shell, apenas ao binário do Borg.
- **Validação Automática:** O script de backup agora executa `borg check` após cada envio.
- **Retenção (Pruning):** Mantém automaticamente os últimos 7 backups diários e 4 semanais.

## 🛠️ Comandos Úteis e Restauração

- **Restaurar Arquivos:** `make restore` (Script interativo para escolher o backup e o caminho).
- **Limpar Logs:** `make clean`.
- **Commitar Alterações:** `make git-commit` (Prepara o projeto para subir ao GitHub).

---
*Este projeto foi ajustado para garantir a instalação mais funcional e rápida possível em ambientes Ubuntu 22.04.*
