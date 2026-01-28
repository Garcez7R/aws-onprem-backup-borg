# 🖥️ Guia de Configuração Detalhado: Servidor Local (Debian 13)

O servidor local atua como o **Cofre Central** e o **Orquestrador** de toda a solução. Este guia foca na robustez e segurança do Debian 13.

## 1. Instalação do Sistema
O Debian é escolhido por sua filosofia de estabilidade ("When it's ready"). Para um servidor de backup, recomendamos a instalação "NetInst" apenas com o sistema base e servidor SSH.

### 1.1 Particionamento Estratégico
É uma boa prática separar os dados de backup do sistema operacional:
*   `/` (Root): 20GB (Sistema e Logs).
*   `/borg`: Partição dedicada ou HD externo montado. O Borg armazena tudo em "chunks" (pedaços), e ter uma partição separada evita que o backup lote o disco do sistema e cause um travamento geral.

## 2. Preparação via Makefile
Ao executar `make setup-vm`, o sistema passa por um processo de hardening automatizado:

### 2.1 O Usuário `backup`
Por que criar um usuário específico?
*   **Isolamento**: Se o seu usuário principal for comprometido, os backups estão protegidos sob outra identidade.
*   **Permissões**: O diretório `/borg/repo` pertence exclusivamente a este usuário, com permissões `700` (ninguém mais lê ou escreve).

### 2.2 Geração de Chaves SSH
O script gera chaves do tipo **ED25519**. Elas são menores, mais rápidas e mais seguras que as antigas chaves RSA. Estas chaves não possuem *passphrase* para permitir que o Crontab execute o backup de madrugada sem pedir intervenção humana.

## 3. O Repositório Borg
O repositório não é uma simples pasta com arquivos. É um banco de dados de blocos deduplicados.

### 3.1 Inicialização (O Comando `init`)
```bash
sudo -u backup borg init --encryption=repokey-blake2 /borg/repo
```
*   **repokey-blake2**: Significa que a chave de criptografia fica guardada dentro do próprio repositório (protegida pela sua senha). O BLAKE2 é o algoritmo de hash ultra-rápido que o Borg usa para identificar blocos duplicados.

## 4. Monitoramento e Manutenção
*   **Logs**: Localizados em `/var/log/borg_backup.log`.
*   **Integridade**: O comando `make backup-now` já inclui o `borg check`. Ele lê os blocos e verifica se os hashes batem, garantindo que o que foi gravado não foi corrompido pelo hardware (bit rot).

## 5. Pruning (Política de Retenção)
Não queremos guardar backups para sempre até o disco lotar. Nossa política padrão é:
*   **7 Diários**: Você pode voltar a qualquer dia da última semana.
*   **4 Semanais**: Você pode voltar a qualquer semana do último mês.
Isso é configurado automaticamente no script de disparo.
