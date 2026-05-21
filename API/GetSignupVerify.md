# 認証コード検証

## Endpoint

`POST /signup/verify`

## Request

### Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| Cookie | ○ | `(^|;\s*)signup_session_id=[A-Fa-f0-9]{32}($|;)` | 認証コード検証用セッションID。 |
| Content-Type | ○ | - | `application/x-www-form-urlencoded` |

### Query

なし

### Body

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| code | ○ | `^[0-9]{5}$` | メールで通知した5桁の認証コード。 |

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
| 00000 | 200 | 認証コード検証成功。 |
| 00001 | 400 | `signup_session_id` または `code` が不正、または認証コード不一致。 |
| 90000 | 500 | 想定外のサーバエラー。 |

## Processing

1. `signup_session_id` と `code` の形式を検証する。
2. サインアップセッションを取得し、入力コードと保存コードを照合する。
3. 検証成功時、サインアップセッションを認証済みに更新する。
