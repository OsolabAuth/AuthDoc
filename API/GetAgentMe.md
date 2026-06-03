# GET /agent/me

## 概要

AIエージェントが、自分に発行されたAccess Tokenの主体情報と委譲情報を確認する。

このAPIはagent tokenで呼び出す。人間ユーザーのPortal画面向け情報取得ではない。

## 認証

```text
Authorization: Bearer agent_access_token
```

## Request

```http
GET /agent/me
```

## 処理

1. Bearer tokenの署名と有効期限を検証する。
2. `principal_type=ai_agent` であることを確認する。
3. `sub` のagentがactiveであることを確認する。
4. `delegation_id` が有効で未失効であることを確認する。
5. token claimとDB上の現在状態を組み合わせて返す。

## Response

```json
{
  "agent_id": "agent_abc123",
  "agent_name": "Issue Triage Agent",
  "owner_sub": "user_123",
  "delegation_id": "delegation_001",
  "client_id": "task-management-client",
  "scopes": ["task.read", "task.comment"],
  "expires_at": "2026-06-30T00:00:00Z",
  "principal_type": "ai_agent"
}
```

## Error

| HTTP | error | description |
| :--- | :--- | :--- |
| 401 | `invalid_token` | tokenが不正または期限切れ |
| 403 | `not_agent_token` | 人間ユーザーtokenなど、agent tokenではない |
| 403 | `delegation_revoked` | delegationが失効済み |
