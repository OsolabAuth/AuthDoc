# Redisデータ設計

## データベース番号

| DB番号 | データ種別 | Key | Value | TTL | 備考 |
| :--- | :---: | :--- | :--- | :---: | :--- |
| 1 | 画面ログインセッション | osolab_auth_session_id(HEX32) | session_id<br>osolab_id<br>created_at<br>expires_at<br>latest_auth_at | 2592000 | 認証画面のログイン状態を管理 |
| 2 | 認可コード | code | code<br>osolab_id<br>client_id<br>created_at<br>expires_at<br>scope<br>code_challenge<br>nonce<br>state | 300 | - |
| 3 | アクセストークン | `osolab_id_tokenid_client_id` | token<br>osolab_id<br>client_id<br>created_at<br>expires_at<br>scope | 900 | tokenはHEX16のosolab_id、HEX32のtoken_id、数字32桁のclient_idを `_` 連結 |
| 4 | リフレッシュトークン | `osolab_id_tokenid_client_id` | token<br>osolab_id<br>client_id<br>created_at<br>expires_at<br>scope | 2592000 | tokenはHEX16のosolab_id、HEX32のtoken_id、数字32桁のclient_idを `_` 連結 |
| 5 | 認可セッション | auth_request_session_id(HEX32) | session_id<br>osolab_id<br>client_id<br>expires_at<br>latest_auth_at | 300 | 認可コード発行までの画面用セッション |
| 5 | メール検証セッション | signup_session_id(HEX32) | session_id<br>osolab_id<br>client_id<br>expires_at<br>latest_auth_at | 300 | 認可コード発行までの画面用セッション |
