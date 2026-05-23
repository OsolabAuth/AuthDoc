# ログアウト

## Endpoint

`POST /logout`

## Request

### Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| Cookie | - | `(^|;\s*)(AuthSessionId|AuthRequestSessionId|session_id)=[A-Fa-f0-9]{32}($|;)` | 削除対象のセッションCookie。未指定でも冪等に成功する。 |
| Authorization | - | `^Bearer [A-Za-z0-9._~-]{20,}$` | 削除対象のアクセストークン。指定された場合はアクセストークンセッションも削除する。 |
| Content-Type | - | - | 省略可。指定する場合は `application/x-www-form-urlencoded` |

### Query

なし

### Body

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| logout_all | - | `^(true|false)$` | 全端末ログアウト要求フラグ。未指定時は `false` 扱い。現行実装では入力値を検証し、レスポンスへ返す。 |

## Response

### Header

| Name | Description |
| :--- | :--- |
| Set-Cookie | `AuthSessionId`、`AuthRequestSessionId`、`session_id` を期限切れにして削除する。 |

### Body

| Name | Type | Description |
| :--- | :--- | :--- |
| response_code | string | 処理結果コード。 |
| result | string | `logged_out` または `already_logged_out`。 |
| logout_all | boolean | リクエストで指定された全端末ログアウト要求フラグ。 |

## Response Code

| Code | HTTP Status | Description |
| :--- | :---: | :--- |
| 00000 | 200 | ログアウト成功。セッション未存在の場合も冪等に成功する。 |
| 00001 | 400 | リクエスト形式、`logout_all`、または `Authorization` ヘッダーが不正。 |
| 90000 | 500 | 想定外のサーバエラー。 |

## Processing

1. `Content-Type` が指定されている場合は `application/x-www-form-urlencoded` であることを検証する。
2. `logout_all` が指定されている場合は `true` または `false` であることを検証する。
3. `Authorization` ヘッダーが指定されている場合はBearer形式を検証する。
4. Cookieに認証セッションIDが存在する場合は、Redis上の認証セッションを削除する。
5. Bearerトークンが指定されている場合は、アクセストークンセッションを削除する。
6. `AuthSessionId`、`AuthRequestSessionId`、`session_id` のCookieを削除する。
7. セッション削除結果と `logout_all` を返す。
