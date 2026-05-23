# ログイン状態取得

## Endpoint

`GET /login/status`

## Request

### Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| Cookie | - | `(^|;\s*)(AuthSessionId|session_id)=[A-Fa-f0-9]{32}($|;)` | ログインセッション判定対象。 |

### Query

なし

### Body

なし

## Response

### Header

なし

### Body

| Name | Type | Description |
| :--- | :--- | :--- |
| response_code | string | 処理結果コード。 |
| logged_in | boolean | ログイン状態。 |

## Response Code

| Code | HTTP Status | Description |
| :--- | :---: | :--- |
| 00000 | 200 | 取得成功。 |
| 90000 | 500 | 想定外のサーバエラー。 |

## Processing

1. Cookie からログインセッションID（`AuthSessionId` 優先、互換で `session_id`）を取得する。
2. セッションIDが空の場合は `logged_in=false` を返す。
3. Redisのログインセッションを参照し、存在すれば `logged_in=true` を返す。
