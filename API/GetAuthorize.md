# 認可エンドポイント

## ■ Endpoint
GET /authorize

## Request

### ■ Header
なし。

### ■ Query

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| response_type | ○ | ^code$ | 認可コードフロー固定値 |
| client_id | ○ | ^[0-9]{32}$ | クライアント識別子 |
| redirect_uri | ○ | ^(https://.+&#124;http://localhost(:[0-9]+)?(/.*)?)$ | 認可結果のリダイレクト先。通常は `https`、検証用途の `localhost` のみ `http` を許容 |
| state | ○ | ^.{1,255}$ | CSRF対策用のクライアント状態値 |
| scope | ○ | ^[A-Za-z0-9_ ]+$ | 要求するスコープの空白区切り文字列 |
| code_challenge_method | ○ | ^S256$ | PKCE チャレンジ方式 |
| code_challenge | ○ | ^[A-Za-z0-9._~-]{43,128}$ | PKCE コードチャレンジ |
| nonce | ○ | ^.{1,255}$ | IDトークン再生対策用ノンス |

### ■ Body
なし

## Response

### ■ Header

| Name | Description |
| :--- | :--- |
| Location | リダイレクトレスポンス時のみ。ログイン画面、同意画面、または `redirect_uri` |
| Set-Cookie | 認可セッション発行時に `session_id` を設定 |

### ■ Query
| Name | Type | Description |
| :--- | :--- | :--- |
| code | String | 正常時のみ認可コードを設定 |
| state | String | 正常時のみリクエストのstateを設定 |
| error | String | エラー時のみ |
| error\_description | String | エラー時のみ。エラー内容 |

### ■ ResponseCode

| Code | HttpStatusCode | Description |
| :--- | :--- | :--- |
| 00001 | 400/302 | リクエストの内容が異常です。`redirect_uri` が検証済みで利用可能な場合は 302、そうでない場合は 400 |
| 00002 | 400 | 不正なクライアント。`client_id` が未登録または無効 |
| 00005 | 400 | リダイレクトURIが不正 |


## ■ 処理概要
- 認可リクエストを検証する
- Auth Session が有効なら規約・scope 同意状態を確認する
- 未ログイン時は認可セッションを発行し、`Set-Cookie` で `session_id` を払い出して `GET /login` に遷移させる
- Portal UI 方式では `session_id` を `Set-Cookie` で払い出し、`redirect_url` には `session_id` を付与しない
- 同意済みなら認可コードを発行して `redirect_uri` へリダイレクトする
- 未同意なら規約同意画面に遷移させる
- `client_id` と `redirect_uri` が有効で、その後の検証で失敗した場合は `redirect_uri` のQueryに `response_code` を付与してリダイレクトする
- `client_id` が未登録または無効な場合はリダイレクトせず、JSON Body付きで400Errorを返却する
- `redirect_uri` の形式が不正、またはクライアントに未登録の場合はリダイレクトせず、JSON Body付きで400Errorを返却する
