# 認証コード再送

## Endpoint

`POST /signup/resend`

## Request

### Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| Cookie | - | `(^|;\s*)signup_session_id=[A-Fa-f0-9]{32}($|;)` | 認証コード再送対象のサインアップセッションID。 |
| x-signup-session-id | - | `^[A-Fa-f0-9]{32}$` | Cookieの代替で `signup_session_id` を指定する場合に利用。 |
| Content-Type | ○ | - | `application/x-www-form-urlencoded` |

### Query

なし

### Body

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| signup_session_id | - | `^[A-Fa-f0-9]{32}$` | Cookie/ヘッダー未指定時の代替入力。 |

## Response

### Header

なし

### Body

| Name | Type | Description |
| :--- | :--- | :--- |
| StatusCode | string | 処理結果コード。 |
| Message | string | エラーまたは補足メッセージ。 |

## Response Code

| Code | HTTP Status | Description |
| :--- | :---: | :--- |
| 00000 | 200 | 認証コード再送成功。 |
| 00001 | 400 | `signup_session_id` が不正、またはセッションが無効。 |
| 90000 | 500 | 想定外のサーバエラー。 |

## Processing

1. `signup_session_id`（フォーム/ヘッダー/Cookie）を取得し形式検証する。
2. サインアップセッションを取得し、有効性を検証する。
3. 認証コードを再発行してメール送信する。
4. セッションの `verified` を `false` に戻して保存する。
