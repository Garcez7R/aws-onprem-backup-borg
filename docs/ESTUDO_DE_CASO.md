# Estudo de Caso: Automação de Backup Híbrido e Resiliência de Dados

## 1. Introdução
Este estudo analisa a implementação de uma arquitetura de backup "Pull" conectando ambientes de nuvem pública (AWS) a infraestruturas privadas (On-Premise). O objetivo é demonstrar como ferramentas de código aberto podem criar soluções de nível corporativo com custo próximo de zero.

## 2. Problemática: O Desafio do Backup em Nuvem
Manter dados exclusivamente na nuvem cria uma dependência crítica do provedor. Além disso, o custo de tráfego de saída (*data egress*) pode ser proibitivo para grandes volumes de dados.

### 2.1 Objetivos Técnicos
*   Minimizar o tráfego de rede via deduplicação na fonte.
*   Garantir a soberania dos dados em hardware local.
*   Eliminar a necessidade de intervenção humana (Zero Touch).

## 3. Metodologia e Ferramentas

### 3.1 BorgBackup: A Escolha Tecnológica
O Borg foi selecionado por sua eficiência matemática. Ao quebrar arquivos em blocos de tamanho variável, ele consegue identificar semelhanças mesmo que partes do arquivo tenham sido movidas ou alteradas.
*   **LZ4**: Escolhido como algoritmo de compressão por oferecer o melhor equilíbrio entre velocidade e taxa de redução.

### 3.2 Arquitetura de Pull vs. Push
No modelo **Push**, a EC2 teria as chaves do servidor local. Se a EC2 fosse invadida, o invasor poderia apagar os backups no servidor.
No modelo **Pull** (adotado aqui), o servidor local solicita os dados. A EC2 nunca tem permissão de escrita ou deleção no servidor local, criando uma barreira de segurança física e lógica.

## 4. Análise de Resultados (Laboratório)
Através do script `setup_ec2.sh`, geramos arquivos binários aleatórios (Dummies).
*   **Backup 1**: Ocupa o espaço total dos dados (ex: 100MB).
*   **Backup 2 (Sem alterações)**: Ocupa apenas alguns KBs de metadados.
*   **Backup 3 (Com pequenas alterações)**: Ocupa apenas o espaço dos blocos que mudaram.

## 5. Considerações sobre Segurança
A implementação utiliza **SSH Restrito**. Mesmo que a chave SSH da VM Local seja exposta, ela só tem permissão para executar o processo `borg serve` na EC2, impedindo que alguém use essa chave para navegar nos arquivos ou executar outros comandos no servidor de origem.

## 6. Conclusão
A combinação de Debian 13 e Ubuntu 22.04 sob a orquestração do BorgBackup prova ser uma solução robusta para o gerenciamento de desastres, oferecendo segurança criptográfica e eficiência de armazenamento superior a métodos tradicionais de cópia de arquivos.
