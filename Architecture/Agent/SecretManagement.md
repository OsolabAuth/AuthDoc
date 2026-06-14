# AI Agent Secret Management

## 目的

AI Agent Delegated Auth で作成した agent を、安全に継続運用できるようにする。

既存の最小実装では、agent を作成し、`agent_id` / `agent_secret` で短命 token を取得できる。一方で、secret 漏洩時や agent 廃止時に止める手段がないため、以下を追加する。

- `agent_secret` の再発行
- agent の失効

## 前提

- 操作対象 agent は人間ユーザーに所有される。
- 管理操作は高リスク操作として扱う。
- 管理操作には 5 分程度の短命 `step_up_token` を必須にする。
- `step_up_token` の subject は owner user と一致する必要がある。

## 管理対象

```text
User
  owns
Agent
  has active/revoked status
  has secret_hash
  has delegated client_id / scope / expires_at
```

## Secret 再発行

### 方針

`agent_secret` は一度しか表示しない。再表示はせず、必要な場合は新しい secret を発行する。

再発行時には以下を行う。

1. owner user を `owner_email` で特定する。
2. `step_up_token` が owner user の subject に紐づくことを検証する。
3. agent が owner user に属していることを検証する。
4. agent が `active` であることを検証する。
5. 新しい `agent_secret` を生成する。
6. DB には新しい `secret_hash` のみ保存する。
7. 古い `agent_secret` は即時無効にする。
8. 新しい `agent_secret` はレスポンスで一度だけ返す。

## Agent 失効

### 方針

agent を失効すると、以後その agent は token を取得できない。

失効時には以下を行う。

1. owner user を `owner_email` で特定する。
2. `step_up_token` が owner user の subject に紐づくことを検証する。
3. agent が owner user に属していることを検証する。
4. agent の `status` を `revoked` にする。
5. `revoked_at` を記録する。
6. token endpoint では `status=active` 以外を拒否する。

## API

- [POST /agent/{agent_id}/secret](../../API/PostAgentSecret.md)
- [POST /agent/{agent_id}/revoke](../../API/PostAgentRevoke.md)

## 初期実装スコープ

- in-memory store で実装する。
- service/API 単体テストで検証する。
- audit log 永続化は別機能とする。
- delegation 単位の失効は別機能とする。
- DPoP/JWK bound agent は別機能とする。

## テスト観点

- secret 再発行後、旧 secret では token を取得できない。
- secret 再発行後、新 secret では token を取得できる。
- 失効後、agent は token を取得できない。
- owner と `step_up_token` の subject が異なる場合は拒否する。
- 存在しない agent は拒否する。
- 他ユーザー所有 agent の管理操作は拒否する。
