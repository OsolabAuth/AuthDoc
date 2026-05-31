# DELETE /agent/{agent_id}/delegations/{delegation_id}

## 概要

AIエージェントへの委譲を取り消す。

委譲を取り消すと、以後 `/agent/token` でその `client_id` / `scope` 向けtokenを取得できない。既に発行済みの短命tokenは期限切れまで有効にするか、token store / blacklistで即時失効する。

## 認証

- `AuthSessionId` Cookie が必要
- 高リスク設定にする場合はagent管理用の短命step-up grantを要求する

```text
Cookie: AuthSessionId=...
X-Step-Up-Grant: ...
```

## Request

```http
DELETE /agent/agent_abc123/delegations/delegation_001
```

## 処理

1. `AuthSessionId` を検証する。
2. 必要に応じてstep-up grantを検証する。
3. `agent_id` がログインユーザー所有であることを確認する。
4. `delegation_id` が対象agentに紐づくことを確認する。
5. delegationをrevoked状態に更新する。
6. 関連する発行済みtokenを失効対象にする。
7. `agent.delegation_revoked` を監査ログに記録する。

## Response

```json
{
  "delegation_id": "delegation_001",
  "status": "revoked"
}
```

## Error

| HTTP | error | description |
| :--- | :--- | :--- |
| 401 | `login_required` | ログインセッションがない |
| 404 | `agent_not_found` | agentが存在しない、または所有者ではない |
| 404 | `delegation_not_found` | delegationが存在しない |
| 409 | `already_revoked` | delegationが既に失効済み |
