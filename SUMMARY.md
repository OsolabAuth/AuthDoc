# Summary

* [Introduction](README.md)

## API
* [認可エンドポイント](API/GetAuthorize.md)
* [JWKsエンドポイント](API/GetJwks.md)
* [ログイン画面表示](API/GetLogin.md)
* [ログイン状態取得](API/GetLoginStatus.md)
* [UserInfoエンドポイント](API/GetUserinfo.md)
* [OpenID Configurationエンドポイント](API/GetWellKnown.md)
* [認証基盤ログイン](API/PostLogin.md)
* [トークンエンドポイント](API/PostToken.md)

## Architecture
* [認証フロー](Architecture/AuthFlow/AuthorizationCodeFlow.md)
* [認証フロー(省略版)](Architecture/AuthFlow/AuthSimple.md)
* [認証フロー(ポータルサイト)](Architecture/AuthFlow/PortalLogin.md)
* [クライアント登録フロー](Architecture/ClientRegister.md)
* [クライアント登録画面設計](Architecture/ClientRegisterScreenDesign.md)
* [Docs Portal アクセス制御構成](Architecture/DocsPortalAccessControl.md)
* [GCP デプロイ構成](Architecture/GcpDeployment.md)
* [JWK鍵管理設計](Architecture/JwkKeyManagement.md)
* [認証画面設計](Architecture/LoginScreenDesign.md)
* [OIDC クライアント構成](Architecture/OidcClientDeployment.md)
* [overview](Architecture/overview.md)

## Data
* [認証基盤のCookie設計](Data/Cookie.md)
* [RDB総合](Data/RDB_Summary.md)
* [クライアント属性許可テーブル](Data/RDB_Table/client_data_key.md)
* [クライアントマスタ](Data/RDB_Table/client_master.md)
* [クライアントリダイレクトURI](Data/RDB_Table/client_redirect_uri.md)
* [クライアント許可Scope](Data/RDB_Table/client_scope.md)
* [属性キー管理マスタ](Data/RDB_Table/data_key_master.md)
* [JWK管理マスタ](Data/RDB_Table/jwk_master.md)
* [Scope-Claimマッピング](Data/RDB_Table/scope_data_key.md)
* [Scope管理マスタ](Data/RDB_Table/scope_master.md)
* [Redisデータ設計](Data/Redis.md)
