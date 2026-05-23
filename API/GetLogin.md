# ログイン画面表示

## ■ Endpoint
GET /login

## Request

### ■ Header
なし

### ■ Query
なし

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
| response_code | String | エラーの場合は必須。レスポンスコード |
| html | String | メールアドレス、パスワード入力欄とログイン送信フォームを含むHTML |

### ■ ResponseCode

| Code | HttpStatusCode | Description |
| :--- | :--- | :--- |
| 00000 | 200 | OK |
| 00001 | 400 | リクエストの内容が異常です |
| 90000 | 500 | ハンドルされていないエラーが発生しました |

## ■ 処理概要
- Portal UI では認可セッションIDをURL queryで受け取らない。`/authorize` の `Set-Cookie` で付与された `AuthRequestSessionId`（互換で `session_id`）を利用する
- セッションが無い場合でも認証画面のみのログインが可能のため、画面は返却する
- メールアドレスとパスワードを入力するための画面を返却する
- ログインボタン押下時に `POST /login` を実行する
- `POST /login` でエラーコード `00006` が返却された場合は、「ログインに成功しましたが、認証の有効期限が切れました。アプリケーションに戻り、再度お試しください。」のメッセージを表示する
- 新規登録リンク押下時も認可セッションIDをURLに付与せず、Cookieで維持する
