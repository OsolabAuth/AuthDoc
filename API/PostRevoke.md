# トークン失効

## Endpoint

`POST /revoke`

## Request

### Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| Authorization | - | `^Basic .+$` | クライアント認証（Base64(client_id:client_secret)）。 |
| Content-Type | ○ | - | `application/x-www-form-urlencoded` |

### Query

なし

### Body

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| token | ○ | `^[A-Za-z0-9._~-]{20,}$` | 失効対象トークン。 |
| token_type | - | `^(access_token|refresh_token)$` | トークン種別。`token_type_hint` でも指定可。 |
| token_type_hint | - | `^(access_token|refresh_token)$` | `token_type` 未指定時の代替入力。 |
| client_id | - | `^[0-9]{32}$` | Basic認証未指定時に必須。 |

## Response

### Header

なし

### Body

| Name | Type | Description |
| :--- | :--- | :--- |
| response_code | string | 処理結果コード。 |
| result | string | `revoked` 固定。 |

## Response Code

| Code | HTTP Status | Description |
| :--- | :---: | :--- |
| 00000 | 200 | 失効成功（対象トークン不存在でも冪等に成功）。 |
| 00001 | 400 | 入力形式またはトークン種別が不正。 |
| 00002 | 400 | クライアント認証失敗。 |
| 90000 | 500 | 想定外のサーバエラー。 |

## Processing

1. `token` と `token_type`（または `token_type_hint`）を検証する。
2. Basic認証がある場合は `client_id` / `client_secret` を検証する。
3. Basic認証がない場合は `client_id` を検証する。
4. `token_type` に応じて該当Redisセッションを探索する。
5. トークンが存在し、かつ `client_id` が一致する場合のみ削除する。
6. 存在しない場合もエラーにせず `revoked` を返す。
