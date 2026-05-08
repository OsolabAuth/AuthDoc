# UserInfoエンドポイント

## ■ Endpoint
GET /userinfo

## Request

### ■ Header

| Name | Required | Regex | Description |
|:---|:---:|:---|:---|
| Authorization | ○ | ^Bearer .+$ | アクセストークン |

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
| sub | String | ユーザー識別子 |
| email | String | メールアドレス。`email` scope 付与時のみ |
| name | String | 表示名。`profile` scope 付与時のみ |
| picture | String | プロフィール画像URL。`profile` scope 付与時のみ |

## ■ 処理概要
- Bearer アクセストークンを検証し、token_id に紐づくトークン情報を取得する
- scope に応じて返却可能なユーザー属性を抽出する
- OpenID Connect UserInfo として返却する
