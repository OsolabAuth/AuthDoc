# 新規登録

## ■ Endpoint
POST /Signup/Account

## ■ Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| Content-Type | ○ | - | application/x-www-form-urlencoded |
| x-session-id | ○ | ^[A-Fa-f0-9]{32}$ | 認可セッションID |

## ■ Request Body

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| email | ○ | ^.+@.+$ | 登録対象メールアドレス |
| password | ○ | ^.{8,128}$ | クライアント側でハッシュ化済みのパスワード |

## Response

### ■ Header
なし

### ■ Body

| Name | Type | Description |
| :--- | :--- | :--- |
| result | String | 処理結果。`pending_verification` |
| message | String | 画面表示用メッセージ |

## ■ 処理概要
- 認可セッションを取得し、対象クライアントを特定する
- メールアドレス重複を確認する
- 仮ユーザーを登録し、メール認証用トークンを発行する
- 認証メールを送信し、メール確認待ち状態を返却する
