# ☁️ Guia de Configuração Detalhado: AWS EC2

Este documento fornece as instruções minuciosas para preparar a instância de origem na Amazon Web Services (AWS).

## 1. Provisionamento da Instância
Para este laboratório/estudo de caso, utilizamos o Ubuntu 22.04 LTS devido à sua vasta documentação e estabilidade com ferramentas de backup modernas.

### 1.1 Detalhes da AMI
*   **Nome:** Ubuntu Server 22.04 LTS (Jammy Jellyfish).
*   **Arquitetura:** x86_64.
*   **Virtualização:** HVM.

### 1.2 Tipo de Instância
*   **Recomendado:** t3.micro (Grátis no Free Tier).
*   **Nota Técnica:** O BorgBackup utiliza CPU para compressão e deduplicação. Em ambientes de produção com TBs de dados, considere instâncias da família `compute-optimized` (C6g/C7g).

## 2. Configuração de Rede e Segurança (Security Groups)
A segurança é baseada no princípio do "Menor Privilégio". Como estamos usando uma arquitetura de **Pull Backup**, a EC2 precisa apenas aceitar conexões SSH.

### 2.1 Regras de Entrada (Inbound)
| Protocolo | Porta | Origem | Justificativa |
| :--- | :--- | :--- | :--- |
| TCP | 22 | IP Fixo da sua VM Local | Permite que o Orquestrador inicie a sessão de backup. |

## 3. Armazenamento (EBS)
*   **Volume Root:** 8GB (GP3 recomendado pela performance de IOPS).
*   **Volumes de Dados:** Se você tiver volumes adicionais montados (ex: `/data`), certifique-se de incluí-los na variável `TARGET_DIRECTORIES` no arquivo `backup.env`.

## 4. Instalação e Preparação Automática
Após acessar sua instância via SSH, o comando `make setup-ec2` realiza as seguintes ações:
1.  **Atualização de Índices**: `apt update`.
2.  **Instalação do Borg**: Instala o binário necessário para que a VM local possa "conversar" com a EC2.
3.  **Geração de Dados de Teste**: Cria a pasta `~/borg_test_data`. Este passo é crucial para o estudo de caso, pois permite observar a deduplicação funcionando na prática:
    *   Arquivos de 2MB, 4MB, 6MB, etc., são gerados aleatoriamente para simular dados reais.

## 5. Autorização SSH (Ponto Crítico)
Para que a automação "Zero Touch" funcione, a chave pública gerada na VM Local deve ser inserida no arquivo:
`~/.ssh/authorized_keys`

**Dica Pro:** Para maior segurança, você pode restringir essa chave para executar apenas o Borg, adicionando o prefixo `command="borg serve",restrict` antes da chave.
