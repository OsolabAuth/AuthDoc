# メール認証

## Endpoint

`GET /signup/verify`

## Request

### Header

なし

### Query

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| token | ○ | `^[A-Za-z0-9_-]{20,}$` | メール認証セッションを識別するトークン。 |
| code | ○ | `^[0-9]{5}$` | メールで通知した5桁の認証コード。 |

### Body

なし

## Response

### Header

| Name | Description |
| :--- | :--- |
| Set-Cookie | メール認証成功時に認証セッションCookieを発行する。互換性のため `AuthSessionId` と `session_id` を設定する。 |
| Location | 認可フロー継続後のリダイレクト先URL。 |

### Body

成功時はリダイレクトするためレスポンスボディは使用しない。
エラー時は以下を返す。

| Name | Type | Description |
| :--- | :--- | :--- |
| StatusCode | string | 処理結果コード。 |
| Message | string | エラーまたは補足メッセージ。 |

## Response Code

| Code | HTTP Status | Description |
| :--- | :---: | :--- |
| 00001 | 400 | `token` または `code` が不正。認証コード不一致、認証セッション不正、仮登録ユーザー不在も含む。 |
| 00003 | 400 | 認可セッションが存在しない、または期限切れ。 |

## Processing

1. `token` と `code` の形式を検証する。
2. メール認証セッションを取得し、認証コードを照合する。
3. 仮登録ユーザーを有効化する。
4. メール認証セッションを削除する。
5. 認証セッションを作成し、Cookieへ保存する。
6. 認可フローを継続し、同意画面またはリダイレクト先へ遷移する。
