# メール認証

## ■ Endpoint
GET /Signup/Verify

## Request

### ■ Header
なし

### ■ Query

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| token | ○ | ^[A-Za-z0-9_-]{20,}$ | メール認証トークン |

### ■ Body
なし

### ■ ResponseCode

| Code | HttpStatusCode | Description |
| :--- | :--- | :--- |
| 00001 | 400 | リクエストの内容が異常です |
| 00003 | 400 | 画面の有効期限が切れました。再度ログインをやり直してください。 |
| 90000 | 500 | ハンドルされていないエラーが発生しました |

## Response

### ■ Header

| Name | Description |
| :--- | :--- |
| Set-Cookie | AuthSessionIdを設定 |
| Location | 認可完了時のリダイレクト先、または規約同意画面 |

### ■ Body
なし

## ■ 処理概要
- メール認証トークンから仮登録ユーザーと認可セッションを取得する
- 仮登録ユーザーを有効化し、メール認証トークンを無効化する
- Auth Session を発行して Cookie に設定する
- 規約同意済みなら認可コードを発行して `redirect_uri` にリダイレクトする
- 未同意なら `GET /terms` へ遷移させる
