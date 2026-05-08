# 規約取得

## ■ Endpoint
GET /terms

## Request

### ■ Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| x-session-id | ○ | ^[A-Fa-f0-9]{32}$ | 認可セッションID |

### ■ Query
なし

### ■ Body
なし

## Response

### ■ Header
なし

### ■ Body

| Name | Type | Description |
| :--- | :--- | :--- |
| client_id | String | 認可セッションに紐づくクライアント識別子 |
| terms | Array<Object> | 同意対象の規約一覧 |
| terms[].term_id | String | 規約識別子 |
| terms[].title | String | 規約名 |
| terms[].version | String | 規約バージョン |
| terms[].required | Boolean | 必須同意かどうか |
| scopes | Array<String> | 認可要求で要求されたスコープ一覧 |

## ■ 処理概要
- `x-session-id` から認可セッションを取得する
- 認可セッションに紐づくクライアントの最新規約と要求 scope を取得する
- 同意画面の描画に必要なデータを返却する
