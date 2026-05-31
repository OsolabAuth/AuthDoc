# POST /agent/token

## 概要

AIエージェントが `agent_id` / `agent_secret` を使って短命のID TokenとAccess Tokenを取得する。

人間ユーザーの通常ログインセッションや通常tokenは使わない。発行されるtokenの `sub` はユーザーではなくAIエージェント自身のIDになる。

## 認証

リクエストbodyで `agent_id` / `agent_secret` を送信する。

```text
Content-Type: application/json
```

## Request

```json
{
  "agent_id": "agent_abc123",
  "agent_secret": "ags_xxxxxxxxxxxxxxxxx",
  "client_id": "task-management-client",
  "scope": "task.read task.comment"
}
```

| field | required | description |
| :--- | :---: | :--- |
| `agent_id` | yes | AIエージェントID |
| `agent_secret` | yes | 一度だけ表示されたagent secret |
| `client_id` | yes | tokenのaudienceとなる対象client |
| `scope` | yes | 要求scope。delegation scopeの部分集合であること |

## 処理

1. `agent_id` が存在しactiveであることを確認する。
2. `agent_secret` をhash照合する。
3. owner userがactiveであることを確認する。
4. `client_id` に対する有効なdelegationを確認する。
5. delegationが未失効かつ有効期限内であることを確認する。
6. 要求scopeがdelegation scopeの部分集合であることを確認する。
7. `sub=agent_id`、`principal_type=ai_agent`、`owner_sub`、`delegation_id` を含むtokenを発行する。
8. `agent.token_issued` または `agent.token_failed` を監査ログに記録する。
9. agentの `last_used_at` を更新する。

## Response

```json
{
  "access_token": "eyJ...",
  "id_token": "eyJ...",
  "token_type": "Bearer",
  "expires_in": 900,
  "scope": "task.read task.comment"
}
```

## ID Token claims

```json
{
  "sub": "agent_abc123",
  "principal_type": "ai_agent",
  "agent_id": "agent_abc123",
  "agent_name": "Issue Triage Agent",
  "owner_sub": "user_123",
  "delegation_id": "delegation_001",
  "amr": ["agent_secret"],
  "acr": "urn:osolab:acr:agent-delegated"
}
```

## Error

| HTTP | error | description |
| :--- | :--- | :--- |
| 400 | `invalid_request` | 入力値が不正 |
| 401 | `invalid_agent` | agent_idまたはagent_secretが不正 |
| 403 | `delegation_revoked` | delegationが失効済み |
| 403 | `delegation_expired` | delegationが期限切れ |
| 403 | `insufficient_scope` | 要求scopeが許可範囲外 |
