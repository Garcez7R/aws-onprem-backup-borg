# 🛡️ Solução de Backup Híbrido: AWS EC2 (Ubuntu 22.04) ↔ VM Local (Debian 13)

Este repositório apresenta uma implementação completa de backup automatizado, seguro e altamente eficiente. O projeto foi desenhado para resolver o desafio de proteger dados críticos na nuvem (AWS) transferindo-os para uma infraestrutura local (On-Premise), utilizando o poder do **BorgBackup**.

## 📖 Visão Geral e Conceitos

Diferente de scripts de cópia comuns (como rsync), esta solução utiliza o **BorgBackup**, que oferece:
*   **Deduplicação de Dados**: Apenas blocos únicos são armazenados. Se você tem 10 arquivos iguais, o Borg armazena apenas um. Isso reduz drasticamente o uso de disco e a largura de banda.
*   **Compressão LZ4**: Os dados são compactados antes do envio, acelerando a transferência.
*   **Criptografia AES-256**: Seus dados são criptografados na origem. Nem o provedor de nuvem nem ninguém no caminho pode ler seu conteúdo.
*   **Arquitetura Pull (Puxada)**: Por segurança, a sua VM Local "puxa" os dados da AWS. Isso impede que uma EC2 comprometida tenha permissão de apagar seus backups locais.

---

## 🏗️ Estrutura do Projeto

O projeto está organizado de forma modular para facilitar o estudo e a manutenção:

*   📂 `config/`: Contém o arquivo `backup.env`, onde centralizamos todas as variáveis (IPs, Senhas, Caminhos).
*   📂 `scripts/`: O motor da automação.
    *   `setup_vm.sh`: Prepara o servidor Debian (Instalação, Usuários, Chaves).
    *   `setup_ec2.sh`: Prepara o cliente Ubuntu (Instalação, Dados de Teste).
    *   `run_backup_automated.sh`: Script orquestrador que realiza o backup, limpeza e validação.
*   📂 `docs/`: Documentação técnica aprofundada.
    *   `ESTUDO_DE_CASO.md`: Análise teórica e técnica da solução.
    *   `AWS_SETUP.md`: Passo a passo detalhado na console AWS.
    *   `DEBIAN_SETUP.md`: Guia de preparação do servidor local.
    *   `NOTIFICACOES.md`: Como configurar alertas no Discord/Slack.

---

## 🚀 Guia de Implementação (Passo a Passo Detalhado)

### 1. Preparação da VM Local (Debian 13)
O primeiro passo é preparar o seu "Cofre de Dados".
```bash
make setup-vm
```
**O que este comando faz?**
1. Atualiza os repositórios e instala o `borgbackup`.
2. Cria um usuário de sistema chamado `backup` (sem acesso a shell por segurança).
3. Cria o diretório `/borg/repo` com permissões restritas.
4. Gera um par de chaves SSH (ED25519) exclusivo para o backup.
5. **Ação Necessária**: Copie a chave pública que aparecerá no seu terminal.

### 2. Preparação da EC2 (Ubuntu 22.04)
Agora, vamos preparar a fonte dos dados.
```bash
make setup-ec2
```
**O que este comando faz?**
1. Instala o Borg no Ubuntu.
2. Cria uma pasta `~/borg_test_data` com arquivos binários de teste (Dummies).
3. **Ação Necessária**: Adicione a chave da VM no arquivo da EC2:
   ```bash
   echo "COLE_A_CHAVE_AQUI" >> ~/.ssh/authorized_keys
   ```

### 3. Configuração do Orquestrador (Na VM Local)
Renomeie o arquivo de exemplo e preencha as informações:
```bash
cp config/backup.env.example config/backup.env
nano config/backup.env
```
Preencha o `REMOTE_EC2_IP` e defina uma senha forte em `BORG_PASSPHRASE`.

### 4. Inicialização do Repositório
Antes do primeiro backup, o "cofre" precisa ser inicializado:
```bash
sudo -u backup borg init --encryption=repokey-blake2 /borg/repo
```

### 5. Execução e Validação
Para disparar o processo completo:
```bash
make backup-now
```
O script irá:
1. Conectar na EC2 via SSH.
2. Ler os dados e aplicar deduplicação.
3. Transferir os blocos novos para a VM.
4. **Pruning**: Apagar backups muito antigos (mantendo os últimos 7 dias).
5. **Check**: Verificar se o repositório está saudável.

---

## 🛠️ Comandos do Makefile
*   `make help`: Lista todos os comandos.
*   `make logs`: Acompanha o progresso do backup em tempo real.
*   `make clean-logs`: Limpa o histórico de logs para economizar espaço.

---
*Este repositório é um material de estudo sobre infraestrutura resiliente e automação de segurança.*
