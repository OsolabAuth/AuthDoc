# Redisデータ設計

## データベース番号

| DB番号 | データ種別 | Key | Value | TTL | 備考 |
| :--- | :---: | :--- | :--- | :---: | :--- |
| 1 | 画面ログインセッション | `login_session:{session_id}` | session_id<br>osolab_id<br>email<br>client_id<br>created_at<br>expires_at<br>latest_auth_at | `Session_ExpireSec` | 認証画面のログイン状態を管理 |
| 2 | 認可コード | `auth_code:{code}` | code<br>osolab_id<br>email<br>client_id<br>redirect_uri<br>scope<br>code_challenge<br>code_challenge_method<br>nonce<br>state<br>expire_at | `AuthCode.EXPIRE_SEC` (300) | - |
| 3 | アクセストークン | `access_token:{osolab_id_tokenid_client_id}` | access_token<br>osolab_id<br>client_id<br>scope<br>expire_at | `AccessToken_ExpireSec` | tokenは `osolab_id(HEX16)_token_id(HEX32)_client_id(数字32桁)` |
| 4 | リフレッシュトークン | `refresh_token:{osolab_id_tokenid_client_id}` | refresh_token<br>osolab_id<br>client_id<br>scope<br>expire_at | `RefreshToken_ExpireSec` | tokenは `osolab_id(HEX16)_token_id(HEX32)_client_id(数字32桁)` |
| 6 | 認可セッション | `auth_request_session:{auth_request_session_id}` | auth_request_session_id<br>response_type<br>client_id<br>redirect_uri<br>state<br>scope<br>code_challenge_method<br>code_challenge<br>nonce<br>osolab_id<br>expires_at | `AuthCode.EXPIRE_SEC` (300) | 認可コード発行までの画面用セッション |
| 7 | メール検証セッション | `signup_session:{signup_session_id}` | signup_session_id<br>auth_request_session_id<br>email<br>code<br>verified<br>created_at<br>expires_at | `SignupSession.ExpireSeconds` (1800) | サインアップ用メール認証セッション |
