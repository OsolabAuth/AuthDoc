# 新規登録

## ■ Endpoint
POST /signup/account

## ■ Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| Content-Type | ○ | - | application/x-www-form-urlencoded |
| x-session-id | ○ | ^[A-Fa-f0-9]{32}$ | 認可セッションID |

## ■ Request Body

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| email | ○ | ^.+@.+$ | 登録対象メールアドレス |
| password | ○ | ^[A-Fa-f0-9]{64}$ | SHA-256 の 16進文字列(64桁) |

## Response

### ■ Header
なし

### ■ Body

| Name | Type | Description |
| :--- | :--- | :--- |
| result | String | 処理結果。`pending_verification` |
| message | String | 画面表示用メッセージ |

### ■ ResponseCode

| Code | HttpStatusCode | Description |
| :--- | :--- | :--- |
| 00000 | 200 | OK |
| 00001 | 400 | リクエストの内容が異常です |
| 00003 | 400 | 画面の有効期限が切れました。再度ログインをやり直してください。 |
| 90000 | 500 | ハンドルされていないエラーが発生しました |
| 90001 | 500 | ID生成に失敗しました |

## ■ 処理概要
- 認可セッションを取得し、対象クライアントを特定する
- メールアドレス重複を確認する
- 仮ユーザーを登録し、メール認証用トークンを発行する
- 認証メールを送信し、メール確認待ち状態を返却する
