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

### ■ ResponseCode

| Code | HttpStatusCode | Description |
| :--- | :--- | :--- |
| 00000 | 200 | OK |
| 00001 | 400 | リクエストの内容が異常です |
| 00003 | 400 | 画面の有効期限が切れました。再度ログインをやり直してください。 |
| 90000 | 500 | ハンドルされていないエラーが発生しました |

## ■ 処理概要
- `x-session-id` から認可セッションを取得する
- 認可セッションに紐づくクライアントの最新規約と要求 scope を取得する
- 同意画面の描画に必要なデータを返却する
