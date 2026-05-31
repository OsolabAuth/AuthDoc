# GET /agent/audit-logs

## 概要

ログイン済みユーザーが、自分のAIエージェントに関する監査ログを取得する。

全体監査ログとは別に、agent管理画面で確認しやすいようにagent関連イベントへ絞る。

## 認証

```text
Cookie: AuthSessionId=...
```

## Request

```http
GET /agent/audit-logs?agent_id=agent_abc123&limit=50
```

| query | required | description |
| :--- | :---: | :--- |
| `agent_id` | no | 指定したagentに絞り込む |
| `event_type` | no | `agent.token_issued` などのイベント種別 |
| `from` | no | 取得開始日時 |
| `to` | no | 取得終了日時 |
| `limit` | no | 最大件数 |

## 処理

1. `AuthSessionId` を検証する。
2. owner userに紐づくagentだけを検索対象にする。
3. query条件で監査ログを絞り込む。
4. secret値やtoken値などの機微情報は返さない。

## Response

```json
{
  "items": [
    {
      "audit_log_id": "audit_001",
      "event_type": "agent.token_issued",
      "agent_id": "agent_abc123",
      "owner_sub": "user_123",
      "delegation_id": "delegation_001",
      "client_id": "task-management-client",
      "scope": "task.read task.comment",
      "result": "success",
      "created_at": "2026-05-31T00:00:00Z"
    }
  ]
}
```

## Error

| HTTP | error | description |
| :--- | :--- | :--- |
| 401 | `login_required` | ログインセッションがない |
| 400 | `invalid_request` | query条件が不正 |
