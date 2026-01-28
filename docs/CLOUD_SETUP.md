# ☁️ Guia de Configuração: Cliente em Nuvem (Cloud)

Este documento fornece as instruções para preparar a instância de origem em um ambiente de nuvem pública.

## 1. Provisionamento da Instância
Para este laboratório e demonstração técnica, utilizamos o **Ubuntu 22.04 LTS** devido à sua vasta documentação e estabilidade com ferramentas de backup modernas.

### 1.1 Recomendações de Instância
*   **Tipo:** t3.micro (ou equivalente conforme o volume de dados).
*   **Nota Técnica:** O BorgBackup utiliza CPU para compressão e deduplicação. Em ambientes de produção com grandes volumes de dados, considere instâncias otimizadas para computação.

## 2. Configuração de Segurança (Firewall/Security Groups)
A segurança é baseada no princípio do **Menor Privilégio**. Como utilizamos uma arquitetura de **Pull Backup**, o cliente precisa apenas aceitar conexões SSH de origens confiáveis.

### 2.1 Regras de Entrada
| Protocolo | Porta | Origem | Justificativa |
| :--- | :--- | :--- | :--- |
| TCP | 22 | IP do Servidor Local | Permite que o Orquestrador inicie a sessão de backup. |

## 3. Instalação e Preparação
Após o acesso à instância, o comando `make setup-ec2` realiza:
1.  **Instalação do Borg**: Instala o binário necessário para a comunicação.
2.  **Dados de Teste**: Cria a pasta `~/borg_test_data` com arquivos binários aleatórios para validar a eficiência da deduplicação.

## 4. Autorização SSH
Para que a automação funcione, a chave pública gerada no servidor local deve ser inserida no arquivo:
`~/.ssh/authorized_keys`

**Dica de Hardening:** Para restringir o acesso, utilize o prefixo `command="borg serve",restrict` antes da chave no arquivo `authorized_keys`.
