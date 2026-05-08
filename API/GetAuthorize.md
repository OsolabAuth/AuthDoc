# 認可エンドポイント

## ■ Endpoint
GET /authorize

## Request

### ■ Header
なし

### ■ Query

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| response_type | ○ | ^code$ | 認可コードフロー固定値 |
| client_id | ○ | ^[A-Za-z0-9]{32}$ | クライアント識別子 |
| redirect_uri | ○ | ^(https://.+\|http://localhost(:[0-9]+)?(/.*)?)$ | 認可結果のリダイレクト先。通常は `https`、検証用途の `localhost` のみ `http` を許容 |
| state | ○ | ^.{1,255}$ | CSRF対策用のクライアント状態値 |
| scope | ○ | ^[A-Za-z0-9_ ]+$ | 要求するスコープの空白区切り文字列 |
| code_challenge_method | ○ | ^S256$ | PKCE チャレンジ方式 |
| code_challenge | ○ | ^[A-Za-z0-9._~-]{43,128}$ | PKCE コードチャレンジ |
| nonce | ○ | ^.{1,255}$ | IDトークン再生対策用ノンス |

### ■ Body
なし

## Response

### ■ Header

| Name     | Description　　　　　　　　　　　　　　　　　 |
| :---------| :----------------------------------------------|
| Location | ログイン画面、同意画面、または `redirect_uri` |

### ■ Body
| Name | Type | Description |
| :--- | :--- | :--- |
| code | String | エラーの場合、レスポンスコード |

### ■ ResponseCode

| Code | HttpStatuCode | Description |
| :--- | :--- | :--- |
| 00001 | 400 | リクエストパラメータが異常 |
| 00002 | 400 | 不正なクライアントIDを指定 |
| 00005 | 400 | リダイレクトURIが不正 |


## ■ 処理概要
- 認可リクエストを検証する
- Auth Session が有効なら規約・scope 同意状態を確認する
- 未ログイン時は認可セッションを発行しクエリに付与して `GET /login` に遷移させる
- 同意済みなら認可コードを発行して `redirect_uri` へリダイレクトする
- 未同意なら `GET /terms` に遷移させる
