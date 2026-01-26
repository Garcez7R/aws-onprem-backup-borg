# Guia de Configuração: Servidor Debian 13 (Destino)

Este documento descreve como preparar a VM local que receberá os backups da AWS.

## 1. Requisitos de Hardware
- **SO:** Debian 13 (Stable) - Instalação Minimal (NetInst).
- **vCPU:** 1 vCPU é suficiente.
- **RAM:** 1GB a 2GB.
- **Disco:** Espaço suficiente para os backups (ex: 50GB+), preferencialmente em uma partição separada para `/borg`.

## 2. Configuração de Rede
Para que a AWS consiga enviar os dados, sua VM precisa de um endereço acessível:
- **IP Fixo:** Configure um IP estático na sua rede local.
- **Port Forwarding:** No seu roteador, redirecione a porta **22 (TCP)** para o IP local da VM Debian.
- **DNS/DDNS:** Se o seu IP de internet for dinâmico, utilize um serviço como No-IP ou DuckDNS.

## 3. Preparação do Sistema
Após instalar o Debian, execute como root:

```bash
# Atualize o sistema
apt update && apt upgrade -y

# Instale dependências básicas
apt install -y sudo git curl borgbackup
```

## 4. Automação com Makefile
Clone o repositório na VM e use o comando Zero Touch:

```bash
git clone https://github.com/Garcez7R/aws-onprem-backup-borg.git
cd aws-onprem-backup-borg

# Configura o usuário 'backup', diretórios e permissões
make setup
```

## 5. Segurança do Usuário Backup
O script `make setup` cria o usuário `backup` sem senha e sem shell interativo por padrão. 
Para finalizar a segurança:
1. Obtenha a chave pública da sua EC2 (`id_borg.pub`).
2. Adicione-a em `/home/backup/.ssh/authorized_keys`.
3. Certifique-se de usar o prefixo de restrição:
   `command="borg serve",restrict ssh-ed25519 AAAA...`

## 6. Firewall (UFW)
Recomendamos ativar o firewall básico:
```bash
apt install ufw
ufw allow 22/tcp
ufw enable
```
