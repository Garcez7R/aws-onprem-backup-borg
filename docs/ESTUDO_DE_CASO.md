# Estudo de Caso: Backup Híbrido AWS → On-Premise (Zero Touch)

## 1. Visão Geral do Projeto
Este projeto simula um cenário real onde dados críticos residentes na nuvem (AWS EC2) precisam ser protegidos em uma infraestrutura local (On-Premise) de forma totalmente automatizada e segura.

## 2. O Desafio
Backups tradicionais muitas vezes falham por:
1.  **Intervenção Humana**: Esquecimento ou erros manuais.
2.  **Custo de Saída**: Transferência de dados ineficiente.
3.  **Segurança**: Exposição de chaves de escrita na nuvem.

## 3. A Solução (Arquitetura Pull)
Invertemos o modelo tradicional. A **VM Local** (mais segura) solicita os dados da **EC2**.
*   **Orquestrador**: Debian 13 (Estável e seguro).
*   **Fonte**: Ubuntu 22.04 (Moderno e compatível).
*   **Motor**: BorgBackup (Deduplicação na fonte).

## 4. Diferenciais Técnicos
- **Zero Touch**: Scripts de setup automatizam a criação de usuários, chaves e dados de teste.
- **Eficiência**: Graças à deduplicação, apenas blocos alterados saem da AWS, reduzindo o custo de *data egress*.
- **Integridade**: Validação automática (`borg check`) após cada operação.

## 5. Resultados de Laboratório
Em testes realizados, o backup inicial de 100MB foi reduzido para apenas alguns KBs em backups subsequentes onde apenas pequenos metadados foram alterados, demonstrando a eficácia do Borg.
