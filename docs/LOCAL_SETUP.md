# 🖥️ Guia de Configuração: Servidor de Backup (Local)

O servidor local atua como o repositório central e o orquestrador de toda a solução. Este guia foca na robustez e segurança utilizando o **Debian 13**.

## 1. Instalação do Sistema
O Debian é escolhido por sua estabilidade. Para um servidor de backup, recomendamos uma instalação enxuta apenas com o sistema base e servidor SSH.

### 1.1 Estratégia de Armazenamento
É uma boa prática separar os dados de backup do sistema operacional:
*   **Partição Root (`/`)**: Destinada ao sistema e logs.
*   **Partição de Dados (`/borg`)**: Partição dedicada ou unidade externa. O Borg armazena dados em blocos, e uma partição separada evita que o backup comprometa a estabilidade do sistema.

## 2. Preparação Automatizada
Ao executar `make setup-vm`, o sistema realiza:
*   **Isolamento de Usuário**: Cria o usuário `backup` para garantir que os processos de backup não rodem como root.
*   **Segurança de Diretório**: O diretório `/borg/repo` é configurado com permissões restritas (`700`).
*   **Chaves SSH**: Gera chaves do tipo **ED25519**, oferecendo maior segurança e performance.

## 3. O Repositório Borg
O repositório é inicializado com criptografia de ponta a ponta.

### 3.1 Inicialização
```bash
make init-repo
```
*   **Criptografia**: Utiliza `repokey-blake2`, onde a chave fica protegida dentro do repositório por uma senha mestra.

## 4. Manutenção e Retenção
O sistema está configurado para manter uma política de retenção equilibrada:
*   **7 Diários**: Proteção contra falhas recentes.
*   **4 Semanais**: Histórico de curto prazo.
*   **Verificação**: O comando de backup inclui validação de integridade dos dados.
