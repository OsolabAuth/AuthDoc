# AIエージェント委譲認証設計

## 目的

人間ユーザーが、自分に紐づくAIエージェントへ限定的な権限を委譲し、AIエージェントがユーザーの代理主体としてクライアントアプリやAPIを利用できるようにする。

AIエージェントには、ユーザーのパスワード、通常ログインセッション、通常IDトークン、通常アクセストークンを渡さない。AIエージェントは専用の `agent_id` / `agent_secret` を使い、短命のエージェント用トークンを取得する。

## 設計方針

- `sub` はAIエージェント自身のIDにする。
- 代理元ユーザーは `owner_sub` としてtoken claimに含める。
- tokenには `principal_type=ai_agent` を含め、人間ユーザー操作とAIエージェント操作を区別できるようにする。
- 委譲範囲は `client_id`、`scope`、`expires_at` で制限する。
- `agent_secret` は一度だけ表示し、DBにはhashのみ保存する。
- agent作成、secret発行、token発行、失敗、失効は監査ログ対象にする。
- 高リスク操作はPhase 1では許可せず、Phase 2で都度承認またはstep-up grantを要求する。

## 初期スコープ

Phase 1でAIエージェントに許可するscopeは、低リスクな課題管理操作に限定する。

- `task.read`
- `task.create`
- `task.comment`

以下はPhase 1では許可しない。

- `task.delete`
- `project.admin`
- `user.invite`
- `permission.change`

## トークンclaim

### ID Token

```json
{
  "iss": "https://auth.osolab-auth.jp/",
  "sub": "agent_abc123",
  "aud": "task-management-client",
  "exp": 1760000000,
  "iat": 1759999100,
  "principal_type": "ai_agent",
  "agent_id": "agent_abc123",
  "agent_name": "Issue Triage Agent",
  "owner_sub": "user_123",
  "delegation_id": "delegation_001",
  "amr": ["agent_secret"],
  "acr": "urn:osolab:acr:agent-delegated"
}
```

### Access Token

```json
{
  "iss": "https://auth.osolab-auth.jp/",
  "sub": "agent_abc123",
  "aud": "task-management-api",
  "exp": 1760000000,
  "iat": 1759999100,
  "jti": "token_001",
  "principal_type": "ai_agent",
  "owner_sub": "user_123",
  "delegation_id": "delegation_001",
  "scope": "task.read task.comment"
}
```

## API境界

画面表示はPortal側の責務とし、Auth backendには画面表示用GET endpointを追加しない。

Auth backendが扱うAPIは以下に限定する。

- [POST /agent](../../API/PostAgent.md)
- [POST /agent/{agent_id}/secret](../../API/PostAgentSecret.md)
- [POST /agent/{agent_id}/delegations](../../API/PostAgentDelegation.md)
- [DELETE /agent/{agent_id}/delegations/{delegation_id}](../../API/DeleteAgentDelegation.md)
- [POST /agent/token](../../API/PostAgentToken.md)
- [GET /agent/me](../../API/GetAgentMe.md)
- [GET /agent/audit-logs](../../API/GetAgentAuditLogs.md)

## シーケンス

詳細なフローは [AI Agent Delegated Auth Flow](../../Sequence/AgentDelegatedAuthFlow.md) を正とする。
