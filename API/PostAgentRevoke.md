# POST /agent/{agent_id}/revoke

AI agent を失効する。

## 目的

不要になった agent や、利用を停止したい agent を失効する。失効後、その agent は `/agent/token` で token を取得できない。

## 認可

この API は高リスク操作として扱い、以下を必須とする。

- owner user の `owner_email`
- owner user に紐づく短命 `step_up_token`
- 操作対象 agent が owner user に属していること

## Request

Path:

```text
agent_id: 失効対象のagent ID
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
  "status": "revoked",
  "revoked_at": "2026-06-01T00:00:00Z"
}
```

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

## 検証観点

- 成功時は `status=revoked` が返る。
- 成功時は `revoked_at` が返る。
- 失効後は `/agent/token` が失敗する。
- 存在しない agent は失敗する。
- 他ユーザー所有 agent は失敗する。
