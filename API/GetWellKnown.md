# OpenID Configurationエンドポイント

## ■ Endpoint
GET /.well-known/openid-configuration

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
```json
{
  "issuer": "https://auth.osolab-auth.jp/",
  "authorization_endpoint": "https://auth.osolab-auth.jp/authorize",
  "token_endpoint": "https://auth.osolab-auth.jp/token",
  "userinfo_endpoint": "https://auth.osolab-auth.jp/userinfo",
  "jwks_uri": "https://auth.osolab-auth.jp/jwks",
  "response_types_supported": [
    "code"
  ],
  "subject_types_supported": [ "public" ],
  "id_token_signing_alg_values_supported": [ "RS256" ],
  "scopes_supported": [
    "openid",
    "email",
    "profile"
  ],
  "token_endpoint_auth_methods_supported": [
    "none",
    "client_secret_basic"
  ],
  "claims_supported": [
    "sub",
    "name",
    "email",
    "iss",
    "aud",
    "exp",
    "iat",
    "picture"
  ],
  "service_documentation": "https://osolab.jp/document/auth",
  "code_challenge_methods_supported": ["S256"]
}
```