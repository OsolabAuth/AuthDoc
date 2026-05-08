# 認証基盤ログイン

## ■ Endpoint
POST /login

## Request

### ■ Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| x-session-id | ○ | ^[A-Fa-f0-9]{32}$ | 認可セッションID |
| Content-Type | ○ | - | application/x-www-form-urlencoded |

### ■ Query
なし

### ■ Body

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| email | ○ | ^.+@.+$ | ログイン対象メールアドレス |
| password | ○ | ^[A-Fa-f0-9]{64}$ | SHA-256 の 16進文字列(64桁) |

## Response

### ■ Header

| Name | Description |
| :--- | :--- |
| Set-Cookie | AuthSessionIdを設定 |
| Location | 認可完了時のリダイレクト先、または規約同意画面 |

### ■ Body

| Name | Type | Description |
| :--- | :--- | :--- |
| result | String | 処理結果。`redirect`、`logged_in`、`error` |
| error_code | String | 認証失敗時のエラーコード |
| message | String | 画面表示用メッセージ |

### ■ ResponseCode

| Code | HttpStatusCode | Description |
| :--- | :--- | :--- |
| 00001 | 400 | リクエストの内容が異常です |
| 00003 | 400 | 画面の有効期限が切れました。再度ログインをやり直してください。 |
| 00004 | 400 | メールアドレスまたはパスワードが正しくありません。 |
| 00006 | 400 | ログインには成功しましたが、認可セッションが存在しないためリダイレクトできません。 |
| 90000 | 500 | ハンドルされていないエラーが発生しました |

## ■ 処理概要
- `x-session-id` を用いて認可セッションを取得する
- メールアドレスで有効なユーザーを検索し、パスワードを検証する
- 認証成功時は Auth Session を払い出し、Cookie に設定する
- 規約・scope 同意済みなら認可コードを発行し `redirect_uri` へリダイレクトする
- 未同意なら `GET /terms` へ遷移させる
- セッションが存在しない場合は、Cookieをログイン状態にするが、リダイレクトせずにエラーコードを返却
