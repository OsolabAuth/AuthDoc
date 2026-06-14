# POST /agent/{agent_id}/secret

AI agent の `agent_secret` を再発行する。

## 目的

`agent_secret` が漏洩した場合や、定期的に secret を更新したい場合に、新しい secret を発行する。古い secret は即時無効になる。

## 認可

この API は高リスク操作として扱い、以下を必須とする。

- owner user の `owner_email`
- owner user に紐づく短命 `step_up_token`
- 操作対象 agent が owner user に属していること
- 操作対象 agent が `active` であること

## Request

Path:

```text
agent_id: 再発行対象のagent ID
```

Body:

```json
{
  "owner_email": "owner@example.com",
  "step_up_token": "sup_xxxxxxxxx"
}
```

## Response

```json
{
  "agent_id": "agent_xxxxxxxxx",
  "agent_secret": "ags_xxxxxxxxx",
  "rotated_at": "2026-06-01T00:00:00Z"
}
```

`agent_secret` はこのレスポンスで一度だけ表示する。DB には `secret_hash` のみ保存する。

## Error

### owner / step-up / agent 不正

```json
{
  "response_code": "00008",
  "message": "unauthorized",
  "error": "invalid_token",
  "error_code": "00008",
  "error_description": "unauthorized"
}
```

### active ではない agent

```json
{
  "response_code": "00008",
  "message": "unauthorized",
  "error": "invalid_token",
  "error_code": "00008",
  "error_description": "unauthorized"
}
```

## 検証観点

- 成功時は `agent_secret` が `ags_` で始まる。
- 成功時は `rotated_at` が返る。
- 旧 secret では `/agent/token` が失敗する。
- 新 secret では `/agent/token` が成功する。
