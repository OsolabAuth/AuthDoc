# 新規登録

## Endpoint

`POST /signup/account`

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
| email | ○ | `^.+@.+$` | 登録するメールアドレス。 |
| password | ○ | `^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,64}$` | 登録するパスワード。サーバ側でArgon2idによりハッシュ化して保存する。 |

## Response

### Header

なし

### Body

| Name | Type | Description |
| :--- | :--- | :--- |
| StatusCode | string | 処理結果コード。 |
| Message | string | エラーまたは補足メッセージ。 |
| VerifyUrl | string | メール認証画面のURL。成功時のみ返却する。 |

## Response Code

| Code | HTTP Status | Description |
| :--- | :---: | :--- |
| 00000 | 200 | 登録受付成功。メール認証セッションを作成した。 |
| 00001 | 400 | リクエスト形式、必須パラメータ、メールアドレス、またはパスワードが不正。既に有効な同一メールアドレスが存在する場合も含む。 |
| 00002 | 400 | 認可セッションが参照するクライアントが存在しない、または無効。 |
| 00003 | 400 | 認可セッションが存在しない、または期限切れ。 |
| 90000 | 500 | 想定外のサーバエラー。 |
| 90001 | 500 | ID生成に失敗。 |

## Processing

1. Cookie、フォーム、またはヘッダーから `session_id` を取得する。
2. 認可セッションを取得し、有効期限とクライアントを検証する。
3. メールアドレスとパスワードの形式を検証する。
4. 既に有効な同一メールアドレスが存在しないことを確認する。
5. 仮登録ユーザーを作成または更新する。
6. メール認証セッションを作成し、認証コードと検証URLを発行する。
7. 検証URLをレスポンスとして返す。
