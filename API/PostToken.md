# トークンエンドポイント

## ■ Endpoint
POST /token

## Request

### ■ Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| x-flow-type | ○ | ^AuthorizationCode$ | Authorization Code Flow 固定値 |
| Content-Type | ○ | - | application/x-www-form-urlencoded |
| Authorization | - | ^Basic .+$ | Basic認証を指定する場合に利用。Base64(クライアントID:クライアントシークレット) |

### ■ Query
なし

### ■ Body

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| grant_type | ○ | ^(authorization_code\|refresh_token)$ | トークン発行方式。`authorization_code` または `refresh_token` |
| client_id | - | ^[0-9]{32}$ | Publicクライアントの場合のみ必須 |
| code | - | ^[A-Za-z0-9._~-]{20,}$ | `grant_type=authorization_code` の場合に必須 |
| code_verifier | - | ^[A-Za-z0-9._~-]{43,128}$ | `grant_type=authorization_code` の場合に必須 |
| redirect_uri | - | ^(https://.+\|http://(localhost\|osolab-[A-Za-z0-9-]+-local)(:[0-9]+)?(/.*)?)$ | `grant_type=authorization_code` の場合に必須。認可要求時と同一のURIを要求 |
| refresh_token | - | ^[A-Za-z0-9._~-]{20,}$ | `grant_type=refresh_token` の場合に必須 |

## Response

### ■ Header
なし

### ■ Body

| Name | Type | Description |
| :--- | :--- | :--- |
| response_code | String | 正常時は `00000` を返却。 |
| access_token | String | 発行したアクセストークン。`osolab_id_tokenid_client_id` 形式 |
| refresh_token | String | 発行したリフレッシュトークン。`osolab_id_tokenid_client_id` 形式 |
| token_type | String | トークン種別。`Bearer` |
| expires_in | Number | アクセストークン有効期限秒数 |
| refresh_token_expires_in | Number | リフレッシュトークン有効期限秒数 |
| scope | String | 発行したスコープの空白区切り文字列 |
| id_token | String | `grant_type=authorization_code` の場合に発行したIDトークン |

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
| 00007 | 400 | 無効な grant（認可コード不正 / リフレッシュトークン不正 / クライアント不一致） |
| 90000 | 500 | ハンドルされていないエラーが発生しました |

## ■ 処理概要
- `grant_type=authorization_code` の場合:
  - 認可コードを取得し、有効期限と利用状態を検証する
  - 認可コードに保持した `redirect_uri` とリクエストの `redirect_uri` を完全一致で照合する
  - `code_verifier` と認可コードに保存した `code_challenge` を照合する
  - アクセストークン、リフレッシュトークン、IDトークンを発行する
- `grant_type=refresh_token` の場合:
  - リフレッシュトークンを検証し、クライアント一致を確認する
  - 旧リフレッシュトークンを失効して新しいトークンペアへローテーションする
- `Authorization: Basic` が指定された場合は Basic認証を検証する
- Basic認証が未指定の場合は `client_id` を検証する
- アクセストークンとリフレッシュトークンを返却する（`authorization_code` の場合は `id_token` も返却）
