# POST /agent/token

AI Agentが `agent_id` / `agent_secret` を使って、短命のagent用tokenを取得する。

## Request

```json
{
  "agent_id": "agent_xxx",
  "agent_secret": "ags_xxx",
  "client_id": "00000000000000000000000000000000",
  "scope": "task_read task_comment"
}
```

## Scope policy

要求scopeは次の両方を満たす必要がある。

1. Phase 1の許可リスト内であること
2. agent delegationに保存されたscopeの部分集合であること

許可scope:

- `task_read`
- `task_create`
- `task_comment`

許可リスト外、またはdelegation外のscopeを要求した場合は `invalid_scope` を返す。

## Response

```json
{
  "access_token": "agt_xxx",
  "id_token": "eyJ...",
  "token_type": "Bearer",
  "expires_in": 900,
  "scope": "task_read task_comment"
}
```
