# POST /agent/{agent_id}/delegations

## 概要

AIエージェントに、特定client向けの限定scopeを委譲する。

委譲は `client_id`、`scopes`、`expires_at` で範囲を固定する。AIエージェントが `/agent/token` で要求できるscopeは、このdelegationの範囲内に制限される。

## 認証

- `AuthSessionId` Cookie が必要
- agent管理用の短命step-up grantが必要

```text
Cookie: AuthSessionId=...
X-Step-Up-Grant: ...
Content-Type: application/json
```

## Request

```json
{
  "client_id": "task-management-client",
  "scopes": ["task.read", "task.create", "task.comment"],
  "expires_at": "2026-06-30T00:00:00Z"
}
```

| field | required | description |
| :--- | :---: | :--- |
| `client_id` | yes | 委譲対象client |
| `scopes` | yes | AIエージェントに許可するscope |
| `expires_at` | yes | 委譲の有効期限 |

## 処理

1. `AuthSessionId` を検証する。
2. step-up grantを検証する。
3. `agent_id` がログインユーザー所有であることを確認する。
4. `client_id` が有効であることを確認する。
5. 要求scopeがAIエージェントに許可可能なscopeであることを確認する。
6. `expires_at` が許容範囲内であることを確認する。
7. `agent_delegation` を作成する。
8. `agent.delegation_created` を監査ログに記録する。

## Response

```json
{
  "delegation_id": "delegation_001",
  "agent_id": "agent_abc123",
  "client_id": "task-management-client",
  "scopes": ["task.read", "task.create", "task.comment"],
  "expires_at": "2026-06-30T00:00:00Z",
  "status": "active"
}
```

## Error

| HTTP | error | description |
| :--- | :--- | :--- |
| 401 | `login_required` | ログインセッションがない |
| 403 | `step_up_required` | step-up grantがない、または期限切れ |
| 404 | `agent_not_found` | agentが存在しない、または所有者ではない |
| 404 | `client_not_found` | 対象clientが存在しない |
| 403 | `scope_not_allowed` | AIエージェントに許可できないscopeが含まれる |
