# Guia de Configuração: AWS EC2

Este documento descreve o passo a passo para preparar a instância de origem (cliente) na AWS.

## 1. Lançamento da Instância
- **AMI:** Amazon Linux 2023 ou Ubuntu 22.04 LTS.
- **Tipo:** `t3.micro` (ou `t2.micro` se estiver no Free Tier).
- **Armazenamento:** 8GB (padrão) é suficiente, pois os dados serão enviados para o destino.

## 2. Security Group (Rede)
Configure as seguintes regras para garantir a segurança:

### Regras de Entrada (Inbound)
| Porta | Protocolo | Origem | Descrição |
| :--- | :--- | :--- | :--- |
| 22 | TCP | Seu IP | Acesso administrativo via SSH |

### Regras de Saída (Outbound)
| Porta | Protocolo | Destino | Descrição |
| :--- | :--- | :--- | :--- |
| 22 | TCP | IP da VM Debian | Envio dos dados via Borg (SSH) |
| 443 | TCP | 0.0.0.0/0 | Notificações Webhook (HTTPS) |
| 80 | TCP | 0.0.0.0/0 | Instalação de pacotes (HTTP) |

## 3. Preparação do Ambiente
Após acessar a instância via SSH, você pode usar o `Makefile` do projeto para automatizar tudo:

```bash
# Clone o seu repositório
git clone git@github.com:Garcez7R/aws-onprem-backup-borg.git
cd aws-onprem-backup-borg

# Instale o BorgBackup
make install
```

## 4. Chave SSH para o Backup
Para que a EC2 se comunique com a VM Debian sem senha:
1. Gere a chave na EC2: `ssh-keygen -t ed25519 -f ~/.ssh/id_borg`
2. Copie a chave pública: `cat ~/.ssh/id_borg.pub`
3. Cole no arquivo `authorized_keys` da VM Debian (conforme o guia de segurança).

## 5. Automação (Opcional)
Você pode adicionar o comando `make backup` ao **Crontab** da EC2 para que ele rode automaticamente todos os dias:
```bash
# Exemplo: Todo dia às 03:00 AM
0 3 * * * cd /path/to/repo && make backup
```
