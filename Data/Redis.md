# Redisデータ設計

## データベース番号

| DB番号 | データ種別 | Key | Value | TTL | 備考 |
|:---|:-:|:--|:--|:-:|:--|
| 1 | 画面ログインセッション | session_id | session_id<br>osolab_id<br>created_at<br>expires_at<br>latest_auth_at | 2592000 | 認証画面のログイン状態を管理 |
| 2 | 認可コード | code | code<br>osolab_id<br>client_id<br>created_at<br>expires_at<br>scope<br>code_challenge<br>nonce<br>state | 300 | - |
| 3 | アクセストークン | token | token<br>osolab_id<br>client_id<br>created_at<br>expires_at<br>scope | 900 | - |
| 4 | リフレッシュトークン | token | token<br>osolab_id<br>client_id<br>created_at<br>expires_at<br>scope | 2592000 | - |
| 5 | IDトークンブラックリスト | jti | jti<br>osolab_id<br>client_id<br>revoked_at<br>expires_at<br>scope | IDトークン有効期限の残り秒数 | - |
| 6 | 認可セッション | session_id | session_id<br>osolab_id<br>client_id<br>expires_at<br>latest_auth_at | 300 | 認可コード発行までの画面用セッション |
