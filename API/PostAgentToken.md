# POST /agent/token

AIエージェントが `agent_id` / `agent_secret` を使って短命トークンを取得する。

## Request

- agent_id
- agent_secret
- client_id
- scope

## Response

AIエージェント用IDトークンとアクセストークンを返す。
