# POST /agent/{agent_id}/secret

## 概要

AIエージェント用の `agent_secret` を発行または再発行する。

`agent_secret` はレスポンスで一度だけ表示する。DBには平文保存せず、hashのみ保存する。

## 認証

- `AuthSessionId` Cookie が必要
- agent管理用の短命step-up grantが必要

```text
Cookie: AuthSessionId=...
X-Step-Up-Grant: ...
Content-Type: application/json
```

## Request

```http
POST /agent/agent_abc123/secret
```

再発行時に既存secretを即時失効させる場合:

```json
{
  "rotate": true
}
```

## 処理

1. `AuthSessionId` を検証する。
2. step-up grantを検証する。
3. `agent_id` がログインユーザー所有であることを確認する。
4. 新しい `agent_secret` を発行する。
5. `secret_hash` を保存する。
6. 再発行の場合は旧secretを利用不能にする。
7. `agent.secret_issued` または `agent.secret_rotated` を監査ログに記録する。

## Response

```json
{
  "agent_id": "agent_abc123",
  "agent_secret": "ags_xxxxxxxxxxxxxxxxx",
  "secret_display_once": true
}
```

## Error

| HTTP | error | description |
| :--- | :--- | :--- |
| 401 | `login_required` | ログインセッションがない |
| 403 | `step_up_required` | step-up grantがない、または期限切れ |
| 404 | `agent_not_found` | agentが存在しない、または所有者ではない |
| 409 | `agent_revoked` | agentが失効済み |
