# 📑 Estudo de Caso Profissional: Backup Híbrido AWS → On-Premise

## 1. Sumário Executivo
Este documento apresenta a implementação de uma solução de Disaster Recovery (DR) e Backup Híbrido, conectando a nuvem pública (AWS) a uma infraestrutura local. O foco principal é a **segurança dos dados**, **automação Zero Touch** e **eficiência de custos**.

## 2. Análise do Cenário
Muitas empresas enfrentam altos custos de *data egress* ao realizar backups da nuvem. Além disso, manter backups apenas na nuvem viola a regra de ouro do backup (3-2-1).

### 2.1 Requisitos do Projeto
*   **Imutabilidade Relativa**: Proteção contra deleção acidental na nuvem.
*   **Segurança**: Criptografia de ponta a ponta.
*   **Autonomia**: Funcionamento sem intervenção manual.

## 3. Decisões de Arquitetura

### 3.1 Por que BorgBackup?
O Borg foi escolhido por sua superioridade em:
*   **Deduplicação no Cliente**: Os dados são comparados antes de sair da EC2. Se um bloco já existe na VM Local, ele não é enviado. Isso economiza até 90% de largura de banda.
*   **Criptografia Autenticada**: Garante que ninguém, nem mesmo o provedor de nuvem, veja os dados.

### 3.2 Arquitetura de "Pull" (Puxada)
Ao contrário do modelo "Push" (onde a EC2 envia), o modelo "Pull" (onde a VM Local solicita) aumenta a segurança:
*   A EC2 não precisa conhecer a senha do repositório local.
*   O servidor local não fica exposto à internet para receber conexões.

## 4. Implementação Técnica
A solução utiliza **Ubuntu 22.04** na AWS pela sua estabilidade e **Debian 13** localmente pela sua robustez como servidor.

### 4.1 Fluxo de Dados
1.  **Trigger**: Crontab na VM Local dispara o script.
2.  **Conexão**: SSH via túnel criptografado.
3.  **Processamento**: Borg indexa os arquivos na EC2.
4.  **Transferência**: Apenas blocos novos são enviados via LZ4.
5.  **Finalização**: Validação de integridade e limpeza de snapshots antigos.

## 5. Conclusão
A implementação resultou em um sistema de backup resiliente, que custa frações de soluções proprietárias e oferece controle total sobre a soberania dos dados.
