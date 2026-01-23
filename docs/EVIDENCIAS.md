# Guia de Evidências do Laboratório

Para validar este projeto em um portfólio ou entrevista, capture os seguintes momentos:

## 📸 Prints Recomendados

1. **Instalação:**
   - Output do comando `borg --version` na EC2 e na VM.
2. **Segurança:**
   - Conteúdo do arquivo `authorized_keys` mostrando a restrição `command="borg serve"`.
3. **Execução:**
   - O log do script `run_backup.sh` mostrando as estatísticas de deduplicação.
4. **Validação:**
   - Listagem dos arquivos no repositório com `borg list`.
   - Sucesso no comando `borg extract` para testar o restore.

## 📊 Perguntas de Entrevista (FAQ)

- **Onde fica o backup?** Em um repositório criptografado na VM Debian 13 fora da AWS.
- **Como ele é protegido?** Criptografia AES-256 no repokey e acesso via SSH restrito.
- **Como restaurar?** Usando o comando `borg extract` apontando para o repositório remoto.
- **O que acontece se a AWS cair?** Os dados estão seguros na VM de destino, permitindo a recuperação em qualquer outro ambiente.
