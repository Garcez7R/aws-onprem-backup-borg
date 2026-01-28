# 🖥️ Guia de Configuração Servidor Local (Debian 13)

Este guia detalha a preparação da VM de destino que atuará como o Servidor de Backup.

## 1. Instalação do Sistema Operacional
*   **Distribuição:** Debian 13 (Trixie/Testing ou Stable).
*   **Particionamento Recomendado:**
    *   `/` (Root): 20GB.
    *   `/borg` (Dados): Espaço dedicado (ex: 100GB+ dependendo da retenção).
    *   `swap`: 2GB.

## 2. Pós-Instalação e Hardening
1.  **Atualização do Sistema:**
    ```bash
    apt update && apt upgrade -y
    ```
2.  **Instalação de Ferramentas Essenciais:**
    ```bash
    apt install -y sudo curl git borgbackup zip
    ```
3.  **Criação do Usuário Dedicado:**
    O script `make setup-vm` automatiza a criação do usuário `backup` sem shell de login por segurança.

## 3. Configuração do Repositório Borg
O repositório será inicializado em `/borg/repo`. 
*   **Criptografia:** AES-256 via `repokey-blake2`.
*   **Permissões:** Apenas o usuário `backup` terá acesso de leitura/escrita.

## 4. Automação SSH
A VM gera uma chave ED25519 que deve ser autorizada na EC2. O uso de chaves sem senha permite que o backup rode via `cron` sem intervenção humana.
