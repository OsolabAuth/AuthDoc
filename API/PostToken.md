# トークンエンドポイント

## ■ Endpoint
POST /token

## Request

### ■ Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| x-flow-type | ○ | - | AuthorizationCode |
| Content-Type | ○ | - | application/x-www-form-urlencoded |
| Authorization | - | ^Basic .+$ | ConfidentialまたはInner Client の場合のみ指定する。Base64(クライアントID:クライアントシークレット) |

### ■ Query
なし

### ■ Body

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| grant_type | ○ | ^authorization_code$ | 認可コードフロー固定値 |
| client_id | - | ^[0-9]{32}$ | Publicクライアントの場合のみ必須 |
| code | ○ | ^[A-Za-z0-9._~-]{20,}$ | 認可コード |
| code_verifier | ○ | ^[A-Za-z0-9._~-]{43,128}$ | PKCE コードベリファイア |
| redirect_uri | ○ | ^(https://.+\|http://localhost(:[0-9]+)?(/.*)?)$ | 認可要求時と同一のリダイレクト先。通常は `https`、検証用途の `localhost` のみ `http` を許容 |

## Response

### ■ Header
なし

### ■ Body

| Name | Type | Description |
| :--- | :--- | :--- |
| response_code | String | エラー時のみ返却。レスポンスコード |
| access_token | String | 発行したアクセストークン。`osolab_id_tokenid_client_id` 形式 |
| refresh_token | String | 発行したリフレッシュトークン。`osolab_id_tokenid_client_id` 形式 |
| token_type | String | トークン種別。`Bearer` |
| expires_in | Number | アクセストークン有効期限秒数 |
| refresh_token_expires_in | Number | リフレッシュトークン有効期限秒数 |
| scope | String | 発行したスコープの空白区切り文字列 |
| id_token | String | 発行したIDトークン |

### ■ トークン形式

| 項目 | 形式 | Description |
| :--- | :--- | :--- |
| access_token | `^[A-Fa-f0-9]{16}_[A-Fa-f0-9]{32}_[0-9]{32}$` | `osolab_id(HEX16)_token_id(HEX32)_client_id(数字32桁)` |
| refresh_token | `^[A-Fa-f0-9]{16}_[A-Fa-f0-9]{32}_[0-9]{32}$` | `osolab_id(HEX16)_token_id(HEX32)_client_id(数字32桁)` |

### ■ ResponseCode

| Code | HttpStatusCode | Description |
| :--- | :--- | :--- |
| 00000 | 200 | OK |
| 00001 | 400 | リクエストの内容が異常です |
| 00002 | 400 | 不正なクライアント |
| 00005 | 400 | リダイレクトURIが不正 |
| 00007 | 400 | 認可コードが不正、期限切れ、または使用済みです。 |
| 90000 | 500 | ハンドルされていないエラーが発生しました |
| 90001 | 500 | ID生成に失敗しました |

## ■ 処理概要
- 認可コードを取得し、有効期限と利用状態を検証する
- 認可コードに保持した `redirect_uri` とリクエストの `redirect_uri` を完全一致で照合する
- `code_verifier` と認可コードに保存した `code_challenge` を照合する
- ConfidentialまたはInner Client の場合は `Authorization` ヘッダーを検証する
- Public Client の場合は `client_id`を検証する
- アクセストークン、リフレッシュトークン、ID トークンを発行して返却する
