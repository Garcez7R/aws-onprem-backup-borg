# 🛡️ AWS to On-Prem Backup Borg (Zero Touch)

Solução profissional de backup automatizado entre AWS EC2 (Ubuntu 22.04) e VM Local (Debian 13) utilizando BorgBackup com arquitetura de **Pull Backup**.

## 🚀 Como Iniciar o Laboratório

### 1. Na VM Local (Debian 13)
```bash
make setup-vm
```
*Copie a chave pública gerada.*

### 2. Na EC2 (Ubuntu 22.04)
```bash
make setup-ec2
echo "COLE_A_CHAVE_AQUI" >> ~/.ssh/authorized_keys
```

### 3. Configuração Final (Na VM Local)
1. Renomeie `config/backup.env.example` para `config/backup.env`.
2. Insira o IP da sua EC2 e defina sua senha do Borg.
3. Inicialize o repositório:
```bash
sudo -u backup borg init --encryption=repokey-blake2 /borg/repo
```

### 4. Execução
Dispare o backup manualmente para testar:
```bash
make backup-now
```

## 📅 Automação (Crontab)
Para rodar todos os dias às 03:00 AM, adicione na VM Local:
```bash
0 3 * * * /caminho/do/projeto/scripts/run_backup_automated.sh
```

## 📂 Documentação Adicional
- [Estudo de Caso Profissional](docs/ESTUDO_DE_CASO.md)
- [Guia de Notificações](docs/NOTIFICACOES.md) (Original mantido)

---
*Desenvolvido para máxima automação e segurança.*
