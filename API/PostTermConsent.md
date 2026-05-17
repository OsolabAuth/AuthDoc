# 規約同意

## ■ Endpoint
POST /terms

## Request

### ■ Header

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| Content-Type | ○ | - | application/x-www-form-urlencoded |

### ■ Query
なし

### ■ Body

| Name | Required | Regex | Description |
| :--- | :---: | :--- | :--- |
| session_id | ○ | ^[A-Fa-f0-9]{32}$ | 認可セッションID。Portal UI では `localStorage` から取得してBodyに設定する |
| accepted | ○ | ^(true\|false\|on)$ | 規約同意可否 |
| term_ids | ○ | - | 同意対象規約ID。複数時は同名項目を繰り返す |

## Response

### ■ Header

| Name | Description |
| :--- | :--- |
| Location | 認可コード付与後のリダイレクト先 |

### ■ Body

| Name | Type | Description |
| :--- | :--- | :--- |
| result | String | 処理結果。`redirect` |
| error | String | 同意拒否時のエラーコード。`access_denied` |

### ■ ResponseCode

| Code | HttpStatusCode | Description |
| :--- | :--- | :--- |
| 00001 | 400 | リクエストの内容が異常です |
| 00003 | 400 | 画面の有効期限が切れました。再度ログインをやり直してください。 |
| 90000 | 500 | ハンドルされていないエラーが発生しました |

## ■ 処理概要
- Body の `session_id` から認可セッションを取得する。互換性のため `x-session-id` header も受け付けるが、Portal UI はBodyを使用する
- 最新規約に対する同意情報を登録する
- 同意済みの場合は認可コードを発行し、`redirect_uri` に `code` と `state` を付与してリダイレクトする
- 拒否時は `error=access_denied` を付与してリダイレクトする
