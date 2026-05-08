# トークンエンドポイント

## ■ Endpoint
POST /token

## Request

### ■ Header

| Name | Required | Regex | Description |
|:---|:---:|:---|:---|
| x-flow-type | ○ | - | AuthorizationCode |
| Content-Type | ○ | - | application/x-www-form-urlencoded |
| Authorization | - | ^Basic .+$ | Base64(クライアントID:クライアントシークレット) |

### ■ Query
なし

### ■ Body

| Name | Required | Regex | Description |
|:---|:---:|:---|:---|
| grant_type | ○ | ^authorization_code$ | 認可コードフロー固定値 |
| code | ○ | ^[A-Za-z0-9._~-]{20,}$ | 認可コード |
| code_verifier | ○ | ^[A-Za-z0-9._~-]{43,128}$ | PKCE コードベリファイア |
| redirect_uri | ○ | ^(https://.+|http://localhost(:[0-9]+)?(/.*)?)$ | 認可要求時と同一のリダイレクト先。通常は `https`、検証用途の `localhost` のみ `http` を許容 |

## Response

### ■ Header
なし

### ■ Body

| Name | Type | Description |
|:---|:---|:---|
| access_token | String | 発行したアクセストークン |
| token_type | String | トークン種別。`Bearer` |
| expires_in | Number | アクセストークン有効期限秒数 |
| scope | String | 発行したスコープの空白区切り文字列 |
| id_token | String | 発行したIDトークン |

## ■ 処理概要
- 認可コードを取得し、有効期限と利用状態を検証する
- `code_verifier` と認可コードに保存した `code_challenge` を照合する
- クライアント認証が必要な場合は `Authorization` ヘッダーを検証する
- アクセストークンと ID トークンを発行して返却する
