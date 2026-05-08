# 新規登録画面表示

## ■ Endpoint
GET /signup

## Request

### ■ Header
なし

### ■ Query

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| session_id | ○ | ^[A-Fa-f0-9]{32}$ | 認可セッションID |

### ■ Body
なし

## Response

### ■ Header

| Name | Description |
| :--- | :--- |
| Content-Type | `text/html; charset=UTF-8` |

### ■ Body

| Name | Type   | Description |
| :--- | :--- | :--- |
| html | String | メールアドレス、パスワード入力欄と登録送信フォームを含むHTML |

### ■ ResponseCode

| Code | HttpStatusCode | Description |
| :--- | :--- | :--- |
| 00000 | 200 | OK |
| 00001 | 400 | リクエストの内容が異常です |
| 00003 | 400 | 画面の有効期限が切れました。再度ログインをやり直してください。 |
| 90000 | 500 | ハンドルされていないエラーが発生しました |

## ■ 処理概要
- 認可セッションIDを受け取り、登録完了後に再開する認可要求を特定する
- メールアドレスとパスワードを入力するための登録画面を返却する
- 必須情報がついかされたら画面項目を追加
