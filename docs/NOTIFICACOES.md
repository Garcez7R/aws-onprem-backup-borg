# 🔔 Guia de Notificações e Alertas

Para garantir o monitoramento "Zero Touch", o sistema suporta notificações automáticas via Webhooks.

## 1. Configuração do Webhook (Discord/Slack)
1.  No seu servidor Discord, vá em **Configurações do Canal** > **Integrações** > **Webhooks**.
2.  Crie um novo Webhook e copie a URL.
3.  No projeto, abra o arquivo `config/backup.env` e cole a URL na variável `WEBHOOK_URL`.

## 2. Tipos de Alertas
O script `run_backup_automated.sh` está configurado para enviar:
*   ✅ **Sucesso**: Notificação verde com o nome do snapshot e estatísticas de deduplicação.
*   ❌ **Falha**: Notificação vermelha com o erro específico e alerta para verificação imediata dos logs.

## 3. Logs do Sistema
Todos os detalhes técnicos são registrados em `/var/log/borg_backup.log`. 
Para monitorar em tempo real:
```bash
make logs
```

## 4. Exemplo de Payload (JSON)
O sistema envia um objeto formatado para Discord:
```json
{
  "embeds": [{
    "title": "Backup SUCESSO - AWS-EC2-PROD",
    "description": "Backup realizado com sucesso. Snapshot: ec2-backup-2024-01-27",
    "color": 65280
  }]
}
```
