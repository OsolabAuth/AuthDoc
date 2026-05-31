# POST /agent

## 概要

ログイン済みユーザーが、自分に紐づくAIエージェントを作成する。

このAPIは `agent_master` の作成だけを行う。`agent_secret` の発行と、対象clientへのdelegation作成は別APIで行う。

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
  "agent_name": "Issue Triage Agent"
}
```

| field | required | description |
| :--- | :---: | :--- |
| `agent_name` | yes | ユーザーに表示するAIエージェント名 |

## 処理

1. `AuthSessionId` を検証する。
2. step-up grantのpurposeがagent管理向けで、有効期限内であることを確認する。
3. owner userがactiveであることを確認する。
4. `agent_id` を発行する。
5. `agent_master` をactive状態で作成する。
6. `agent.created` を監査ログに記録する。

## Response

```json
{
  "agent_id": "agent_abc123",
  "agent_name": "Issue Triage Agent",
  "status": "active"
}
```

## Error

| HTTP | error | description |
| :--- | :--- | :--- |
| 401 | `login_required` | ログインセッションがない |
| 403 | `step_up_required` | step-up grantがない、または期限切れ |
| 400 | `invalid_request` | 入力値が不正 |
| 409 | `agent_name_conflict` | 同一ユーザー内でエージェント名が重複 |
