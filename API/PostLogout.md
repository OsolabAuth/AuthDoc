# ログアウト

## ■ Endpoint
POST /Logout

## Request

### ■ Header

| Name | Required | Regex | Description |
|:---|:---:|:---|:---|
| Cookie | ○ | - | AuthSessionId を含む |
| Authorization | - | ^Bearer .+$ | 失効対象アクセストークン |
| Content-Type | ○ | - | application/x-www-form-urlencoded |

### ■ Query
なし

### ■ Body

| Name | Required | Regex | Description |
|:---|:---:|:---|:---|
| logout_all | ○ | ^(true|false)$ | 全端末ログアウト要否 |

## Response

### ■ Header

| Name | Description |
|:---|:---|
| Set-Cookie | AuthSessionId削除 |

### ■ Body

| Name | Type | Description |
|:---|:---|:---|
| result | String | 処理結果。`logged_out` または `already_logged_out` |

## ■ 処理概要
- Cookie から Auth Session を取得し、存在する場合は削除する
- 指定がある場合は Bearer アクセストークンを失効させる
- ID トークン失効情報を登録する
- `logout_all=true` の場合はユーザー単位の全セッション失効日時を登録する
