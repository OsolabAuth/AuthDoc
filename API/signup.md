# アカウント登録

## Endpoint

`POST /signup/account`

## Request

### Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| Cookie | - | `(^|;\s*)signup_session_id=[A-Fa-f0-9]{32}($|;)` | 認証コード検証済みのサインアップセッションID。 |
| x-signup-session-id | - | `^[A-Fa-f0-9]{32}$` | Cookieの代替で `signup_session_id` を指定する場合に利用。 |
| Content-Type | ○ | - | `application/x-www-form-urlencoded` |

### Query

なし

### Body

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| signup_session_id | - | `^[A-Fa-f0-9]{32}$` | Cookie/ヘッダー未指定時の代替入力。 |
| password | ○ | `^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,64}$` | 登録するパスワード。サーバ側でArgon2idハッシュ化して保存する。 |

## Response

### Header

| Name | Description |
| :--- | :--- |
| Set-Cookie | 登録成功時に `AuthSessionId` と `session_id` を発行する。 |
| Location | 認可フロー再開先のURL。 |

### Body

| Name | Type | Description |
| :--- | :--- | :--- |
| result | string | `redirect` または `error`。 |
| response_code | string | 処理結果コード。 |
| message | string | エラーまたは補足メッセージ。 |

## Response Code

| Code | HTTP Status | Description |
| :--- | :---: | :--- |
| 00000 | 200 | 本登録成功。認可フローを再開する。 |
| 00001 | 400 | リクエスト形式、必須パラメータ、パスワード、認証セッションが不正。既存有効メールアドレスが存在する場合も含む。 |
| 00003 | 400 | 認可セッションが存在しない、または期限切れ。 |
| 90000 | 500 | 想定外のサーバエラー。 |
| 90001 | 500 | ID生成に失敗。 |

## Processing

1. `signup_session_id`（フォーム/ヘッダー/Cookie）と `password` を検証する。
2. サインアップセッションを取得し、認証コード検証済みであることを確認する。
3. メールアドレス重複を再確認し、ユーザーを本登録（有効化）する。
4. ログインセッションを作成し、Cookieへ保存する。
5. サインアップセッションに保持していた認可セッションIDで認可処理を再実行し、`Location` を返す。
