# ログイン画面表示

## ■ Endpoint
GET /login

## Request

### ■ Header
なし

### ■ Query

| Name       | Required | Regex                | Description　　　|
| :-----------| :--------:| :---------------------| :-----------------|
| session_id | ○        | ^[A-Za-z0-9_-]{20,}$ | 認可セッションID |

### ■ Body
なし

## Response

### ■ Header

| Name | Description |
|:---|:---|
| Content-Type | `text/html; charset=UTF-8` |

### ■ Body

| Name | Type | Description |
|:---|:---|:---|
| html | String | メールアドレス、パスワード入力欄とログイン送信フォームを含むHTML |

## ■ 処理概要
- 認可セッションIDを受け取り、ログイン対象の認可処理を特定する
- メールアドレスとパスワードを入力するための画面を返却する
- 必要に応じて新規登録画面への導線を表示する
