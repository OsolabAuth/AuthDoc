# JWKsエンドポイント

## ■ Endpoint
GET /jwks

## Request

### ■ Header
なし

### ■ Query
なし

### ■ Body
なし

## Response
### ■ Header
なし

### ■ Body

| Name | Type | Description |
| :--- | :--- | :--- |
| keys | Array<Object> | 公開鍵一覧 |
| keys[].kid | String | 鍵識別子 |
| keys[].kty | String | 鍵種別。`RSA`固定 |
| keys[].alg | String | 署名アルゴリズム。`RS256`固定 |
| keys[].use | String | 鍵用途。`sig`固定 |
| keys[].n | String | RSA公開鍵の modulus |
| keys[].e | String | RSA公開鍵の exponent |

### ■ ResponseCode

| Code | HttpStatusCode | Description |
| :--- | :--- | :--- |
| 00000 | 200 | OK |
| 90000 | 500 | ハンドルされていないエラーが発生しました |

## 補足

- レスポンスの公開鍵は `auth.jwk_master` の `status=1` レコードから生成する。
- 秘密鍵は `JwkPrivateKeyEncryptionKey` を使って AES-GCM で暗号化保存し、本APIでは公開しない。
