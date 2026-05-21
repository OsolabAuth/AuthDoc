# 認証基盤ログイン

## Endpoint

`POST /login`

## Request

### Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| Cookie | - | `(^|;\s*)session_id=[A-Fa-f0-9]{32}($|;)` | 認可フロー継続用のセッションID。未指定の場合はログインのみ実行する。 |
| Content-Type | ○ | - | `application/x-www-form-urlencoded` |

### Query

なし

### Body

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| email | ○ | `^.+@.+$` | ログイン対象のメールアドレス。 |
| password | ○ | `^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,64}$` | パスワード。TLS上で送信し、サーバ側でArgon2idハッシュと照合する。 |

## Response

### Header

| Name | Description |
| :--- | :--- |
| Set-Cookie | ログイン成功時に認証セッションCookieを発行する。互換性のため `AuthSessionId` と `session_id` を設定する。 |
| Location | 認可フロー継続時、リダイレクト先URLを設定する。 |

### Body

| Name | Type | Description |
| :--- | :--- | :--- |
| response_code | string | 処理結果コード。 |
| result | string | `redirect`、`logged_in`、`error` のいずれか。 |
| message | string | エラーまたは補足メッセージ。 |

## Response Code

| Code | HTTP Status | Description |
| :--- | :---: | :--- |
| 00000 | 200 | ログイン成功。認可セッションが有効な場合は認可フローを継続する。 |
| 00001 | 400 | リクエスト形式または必須パラメータが不正。 |
| 00004 | 400 | メールアドレスまたはパスワードが不正。 |
| 00006 | 200 | ログインは成功したが、認可セッションが存在しない、または期限切れ。 |
| 90000 | 500 | 想定外のサーバエラー。 |

## Processing

1. `Content-Type` とフォームボディを検証する。
2. メールアドレスに対応する有効ユーザーを取得する。
3. Argon2idでパスワードを検証する。
4. 認証セッションを作成し、Cookieへ保存する。
5. 認可セッションが有効な場合は認可フローを継続し、`Location` を返す。
6. 認可セッションがない場合は、ログイン成功として `00006` を返す。
