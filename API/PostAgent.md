# POST /agent

ログイン済みユーザーが、AI Agentを登録し、対象clientへ委譲するscopeを作成する。

このAPIは高リスク操作なので、MFAまたはメール認証で発行された短命の `step_up_token` を必須とする。

## Request

```json
{
  "owner_email": "user@example.com",
  "agent_name": "Issue Triage Agent",
  "client_id": "00000000000000000000000000000000",
  "scope": "task_read task_create task_comment",
  "expires_days": 30,
  "step_up_token": "stp_xxx"
}
```

## Scope policy

Phase 1で作成できるscopeは次に限定する。

- `task_read`
- `task_create`
- `task_comment`

許可リスト外のscopeを含む場合は `invalid_scope` を返す。

## Response

`agent_secret` は一度だけ表示する。

```json
{
  "agent_id": "agent_xxx",
  "agent_secret": "ags_xxx",
  "delegation_id": "del_xxx",
  "scope": "task_read task_create task_comment",
  "expires_at": "2026-06-30T00:00:00+00:00"
}
```
