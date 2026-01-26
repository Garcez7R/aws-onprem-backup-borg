# Configuração de Notificações (Webhooks)

Este projeto suporta alertas automáticos para Discord ou Slack.

## 🎮 Como criar um Webhook no Discord
1. Vá nas **Configurações do Canal** onde deseja receber os alertas.
2. Clique em **Integrações** > **Webhooks** > **Novo Webhook**.
3. Copie a **URL do Webhook**.
4. Cole essa URL na variável `WEBHOOK_URL` dentro do arquivo `scripts/run_backup.sh`.

## 📊 O que será notificado?
- **Sucesso (Verde):** Quando o backup e o prune terminarem sem erros.
- **Erro (Vermelho):** Quando houver falha na conexão, falta de espaço ou erro no Borg.

## 📝 Logs Locais
Além das notificações, todos os detalhes técnicos (estatísticas de deduplicação e compressão) são salvos em:
`/var/log/borg_backup.log`
