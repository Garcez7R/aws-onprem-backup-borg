# ☁️ Guia de Configuração AWS EC2 (Ubuntu 22.04)

Este guia detalha o provisionamento da instância de origem para o sistema de backup.

## 1. Escolha da AMI
Para garantir a máxima compatibilidade e facilidade de instalação do BorgBackup, selecionamos a AMI:
*   **SO:** Ubuntu Server 22.04 LTS (HVM), SSD Volume Type.
*   **Arquitetura:** 64-bit (x86).

## 2. Instância e Recursos
*   **Tipo:** t3.micro (suficiente para laboratório) ou superior para produção.
*   **Armazenamento:** Mínimo 8GB (Root) + Volume adicional se houver dados específicos para backup.

## 3. Security Groups (Firewall)
Para o funcionamento do backup via Pull (VM -> EC2), a EC2 precisa permitir:
| Tipo | Protocolo | Porta | Origem | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| SSH | TCP | 22 | IP_DA_SUA_VM | Acesso para o Orquestrador de Backup |

## 4. Configuração de Acesso
1.  Gere ou importe sua Key Pair (.pem).
2.  Acesse a instância: `ssh -i sua-chave.pem ubuntu@ip-da-ec2`.
3.  Execute o comando de setup do projeto: `make setup-ec2`.

## 5. IAM (Opcional)
Se desejar integrar com S3 futuramente, anexe uma Role com a política `AmazonS3FullAccess`.
