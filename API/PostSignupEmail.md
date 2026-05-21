# 認証コード送信

## Endpoint

`POST /signup/email`

## Request

### Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| Cookie | ○ | `(^|;\s*)session_id=[A-Fa-f0-9]{32}($|;)` | 認可フロー継続用のセッションID。 |
| Content-Type | ○ | - | `application/x-www-form-urlencoded` |

### Query

なし

### Body

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| email | ○ | `^.+@.+$` | 登録対象のメールアドレス。 |

## Response

### Header

| Name | Description |
| :--- | :--- |
| Set-Cookie | 認証コード検証用の `signup_session_id` を発行する。 |

### Body

| Name | Type | Description |
| :--- | :--- | :--- |
| StatusCode | string | 処理結果コード。 |
| Message | string | エラーまたは補足メッセージ。 |

## Response Code

| Code | HTTP Status | Description |
| :--- | :---: | :--- |
| 00000 | 200 | 認証コード送信受付成功。 |
| 00001 | 400 | リクエスト形式、必須パラメータ、メールアドレスが不正。既存有効メールアドレス指定時も含む。 |
| 00003 | 400 | 認可セッションが存在しない、または期限切れ。 |
| 90000 | 500 | 想定外のサーバエラー。 |

## Processing

1. Cookie、フォーム、またはヘッダーから認可セッションIDを取得する。
2. 認可セッションを取得し、有効期限とクライアントを検証する。
3. メールアドレス形式と利用可否を検証する。
4. 認証コードを発行し、`signup_session_id` に紐づけてRedisへ保存する。
5. 認証コードをメール送信し、`signup_session_id` Cookieを返す。
