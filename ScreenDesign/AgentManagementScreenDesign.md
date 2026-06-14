# AI Agent Management Screen

## 目的

AuthPortalからAI Agent Delegated Authの主要操作を確認できるようにする。

初期実装では管理画面を1画面にまとめ、次の操作を行う。

- AI Agent作成
- agent_secret再発行
- agent失効
- agent token取得確認

## 画面構成

### Agent作成

入力:

- owner email
- agent name
- client id
- scope
- expires days
- step-up token

scopeはPhase 1の許可リストから選択する。

- `task_read`
- `task_create`
- `task_comment`

出力:

- `agent_id`
- `agent_secret`
- `delegation_id`
- `scope`
- `expires_at`

`agent_secret` は一度だけ表示される前提のため、画面上に注意文を表示する。

### Secret再発行

入力:

- owner email
- agent id
- step-up token

出力:

- new `agent_secret`
- rotated timestamp

### Agent失効

入力:

- owner email
- agent id
- step-up token

出力:

- status
- revoked timestamp

### Token取得確認

入力:

- agent id
- agent secret
- client id
- requested scope

出力:

- token response JSON

## エラー表示

APIが `error_description` を返す場合はそれを表示する。返さない場合は画面側の固定メッセージを表示する。

## テスト観点

- `npm run typecheck` が成功する。
- scope選択は許可リストのみに限定されている。
- agent作成時に選択scopeを空白区切りで送信する。
- 作成、再発行、失効、token取得のレスポンスを画面に表示できる。
