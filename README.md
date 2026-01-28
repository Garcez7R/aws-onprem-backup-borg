# 🛡️ Hybrid Backup Solution: Cloud & On-Premise Resiliency

[![AWS](https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge&logo=amazon-aws)](https://aws.amazon.com/)
[![Security](https://img.shields.io/badge/Security-Data_Protection-blue?style=for-the-badge&logo=linux-foundation)](https://www.linuxfoundation.org/)
[![BorgBackup](https://img.shields.io/badge/BorgBackup-Deduplication-green?style=for-the-badge&logo=borgbackup)](https://www.borgbackup.org/)
[![Status](https://img.shields.io/badge/Status-Educational-brightgreen?style=for-the-badge)](https://github.com/Garcez7R/aws-onprem-backup-borg)

## 📋 Sobre o Projeto

Este projeto apresenta uma implementação completa de **backup híbrido automatizado**, seguro e altamente eficiente. O objetivo é demonstrar como proteger dados críticos em ambientes de nuvem pública, transferindo-os para uma infraestrutura local (**On-Premise**) de forma resiliente.

A solução utiliza o **BorgBackup** para garantir que os dados sejam deduplicados, compactados e criptografados antes mesmo de saírem da origem, seguindo as melhores práticas de **soberania de dados** e **segurança cibernética**.

### Autor e Informações

| Detalhe | Informação |
| :-- | :-- |
| **Autor** | Rafael Garcez |
| **LinkedIn** | [linkedin.com/in/rgarcez7](https://linkedin.com/in/rgarcez7) |
| **Projeto** | Backup Híbrido Zero-Touch |
| **Foco Técnico** | Infraestrutura, Segurança e Automação |

## 🎯 Objetivos Técnicos

*   **Deduplicação na Fonte:** Redução drástica do tráfego de rede e uso de armazenamento.
*   **Arquitetura Pull:** Proteção contra ataques de ransomware no cliente em nuvem.
*   **Criptografia de Ponta a Ponta:** Garantia de confidencialidade com AES-256.
*   **Automação Zero-Touch:** Orquestração completa via Scripts e Makefile.
*   **Resiliência Híbrida:** Garantia de disponibilidade dos dados fora do provedor cloud.

## 🏗️ Arquitetura da Solução

O projeto baseia-se em um modelo de **Pull Backup**, onde o servidor local inicia a conexão segura e solicita os dados.

| Componente | Função | Tecnologia |
| :-- | :-- | :-- |
| **Cliente Cloud** | Origem dos dados críticos | Ubuntu 22.04 LTS |
| **Servidor Local** | Repositório seguro e orquestrador | Debian 13 |
| **Protocolo** | Transporte seguro de dados | SSH (ED25519) |
| **Motor de Backup** | Deduplicação e Criptografia | BorgBackup |

## 📁 Estrutura do Repositório

```text
aws-onprem-backup-borg/
├── README.md               # Visão geral e guia rápido
├── Makefile                # Interface de automação do projeto
├── config/
│   └── backup.env.example  # Modelo de variáveis de ambiente
├── scripts/
│   ├── setup_vm.sh         # Configuração do Servidor Local
│   ├── setup_ec2.sh        # Configuração do Cliente Cloud
│   └── run_backup.sh       # Script orquestrador de backup
└── docs/
    ├── ESTUDO_DE_CASO.md   # Análise teórica aprofundada
    ├── CLOUD_SETUP.md      # Guia de preparação do cliente
    ├── LOCAL_SETUP.md      # Guia de preparação do servidor
    └── NOTIFICACOES.md     # Configuração de alertas Webhook
```

## 🚀 Guia de Implementação

### 1. Preparação do Servidor Local
```bash
make setup-vm
```
*   Configura o usuário dedicado `backup`.
*   Gera chaves SSH exclusivas.
*   Prepara o diretório do repositório.

### 2. Preparação do Cliente Cloud
```bash
make setup-ec2
```
*   Instala as dependências do Borg.
*   Gera arquivos de teste (**Dummy Data**) para validação.

### 3. Conectividade e Inicialização
1. Adicione a chave pública da VM no cliente cloud.
2. Configure o arquivo `config/backup.env`.
3. Inicialize o repositório:
```bash
make init-repo
```

### 4. Execução do Backup
```bash
make backup-now
```

## 🔐 Tecnologias e Conceitos

### Stack Tecnológica
*   **BorgBackup:** O estado da arte em backup com deduplicação.
*   **Linux (Debian/Ubuntu):** Sistemas operacionais robustos para produção.
*   **Bash Scripting:** Automação de fluxos complexos.
*   **SSH Tunneling:** Comunicação segura e criptografada.

### Conceitos Aplicados
*   **Least Privilege:** Usuário de backup sem acesso a shell.
*   **Pull vs Push:** Inversão de controle para maior segurança.
*   **Immutable-ish Backups:** Proteção do repositório local.
*   **Data Integrity:** Verificação constante via hashes (Check).

## 🎓 Competências Demonstradas

*   ✅ Implementação de arquiteturas híbridas de TI.
*   ✅ Gestão avançada de sistemas Linux.
*   ✅ Automação de processos de segurança e infraestrutura.
*   ✅ Configuração de ambientes cloud resilientes.
*   ✅ Documentação técnica de nível corporativo.

## 📚 Referências e Recursos

*   [BorgBackup Official Documentation](https://www.borgbackup.org/)
*   [Linux Security Hardening Guide](https://www.cisecurity.org/)
*   [SSH Best Practices](https://www.ssh.com/academy/ssh/best-practices-security)

## 📞 Contato

*   **Rafael Garcez**
*   **LinkedIn:** [linkedin.com/in/rgarcez7](https://linkedin.com/in/rgarcez7)

---
⭐ Se este projeto foi útil para seus estudos de infraestrutura, considere deixar uma estrela no repositório!
