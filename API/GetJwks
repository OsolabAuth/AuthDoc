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
|:---|:---|:---|
| keys | Array<Object> | 公開鍵一覧 |
| keys[].kid | String | 鍵識別子 |
| keys[].kty | String | 鍵種別。`RSA`固定 |
| keys[].alg | String | 署名アルゴリズム。`RS256`固定 |
| keys[].use | String | 鍵用途。`sig`固定 |
| keys[].n | String | RSA公開鍵の modulus |
| keys[].e | String | RSA公開鍵の exponent |
