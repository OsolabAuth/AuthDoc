# UserInfoエンドポイント

## ■ Endpoint
GET /userinfo

## Request

### ■ Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| Authorization | ○ | ^Bearer [A-Fa-f0-9]{16}_[A-Fa-f0-9]{32}_[0-9]{32}$ | アクセストークン |

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
| sub | String | ユーザー識別子 |
| email | String | メールアドレス。`email` scope 付与時のみ |
| name | String | 表示名。`profile` scope 付与時のみ |
| picture | String | プロフィール画像URL。`profile` scope 付与時のみ |

### ■ ResponseCode

| Code | HttpStatusCode | Description |
| :--- | :--- | :--- |
| 00000 | 200 | OK |
| 00001 | 400 | リクエストの内容が異常です |
| 00008 | 401 | 認可がありません。 |
| 90000 | 500 | ハンドルされていないエラーが発生しました |

## ■ 処理概要
- Bearer アクセストークンを検証し、アクセストークン値をキーとしてトークン情報を取得する
- scope に応じて返却可能なユーザー属性を抽出する
- OpenID Connect UserInfo として返却する
