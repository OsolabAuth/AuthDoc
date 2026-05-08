# ログイン画面表示

## ■ Endpoint
GET /login

## Request

### ■ Header
なし

### ■ Query

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| session_id | - | ^[A-Fa-f0-9]{32}$ | 認可セッションID |

### ■ Body
なし

## Response

### ■ Header

| Name | Description |
| :--- | :--- |
| Content-Type | `text/html; charset=UTF-8` |

### ■ Body

| Name | Type | Description |
| :--- | :--- | :--- |
| html | String | メールアドレス、パスワード入力欄とログイン送信フォームを含むHTML |

### ■ ResponseCode

| Code | HttpStatusCode | Description |
| :--- | :--- | :--- |
| 00000 | 200 | OK |
| 00001 | 400 | リクエストの内容が異常です |
| 90000 | 500 | ハンドルされていないエラーが発生しました |

## ■ 処理概要
- 認可セッションIDを受け取り、ログイン対象の認可処理を特定する
- セッションが無い場合でも認証画面のみのログインが可能のため、画面は返却する
- メールアドレスとパスワードを入力するための画面を返却する
- ログインボタン押下時に `POST /Login` を実行
- `POST /Login` でエラーコード00006が返却された場合、"ログインに成功しましたが、認証の有効期限が切れました。アプリケーションに戻り、再度お試しください"のメッセージを表示する
- 新規登録リンク押下時にはsession_idを引き継いで `Get /Signup` にリダイレクト
