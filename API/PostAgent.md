# POST /agent

ログイン済みユーザーがAIエージェントを登録する。

## Request

- agent_name: エージェント名
- client_id: 対象クライアント
- scopes: 委譲するscope
- expires_at: 委譲期限

## Response

一度だけ表示する `agent_secret` と `agent_id` を返す。
