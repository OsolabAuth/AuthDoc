# OIDC クライアント構成

`oidc-sample-client` を実サービス化する場合の構成案です。
静的 HTML だけではアプリ用 DB と安全な `client_secret` 管理ができないため、Backend for Frontend または API backend を追加します。

```plantuml
@startuml
title OIDC Client Application Deployment

skinparam componentStyle rectangle
skinparam shadowing false

actor "User / Browser" as user

cloud "Cloud Run" as cloudrun {
  component "client-web\nStatic UI" as web
  component "client-bff\nOIDC callback / session" as bff
  component "authfoundation-api\nOIDC Provider" as auth
}

database "Client DB\nApp users / roles / app data" as clientdb
database "Auth DB\nOsolabAuth" as authdb
database "Redis\nAuth sessions / tokens" as redis

user --> web : open app
web --> bff : /login
bff --> auth : /authorize redirect
auth --> user : login / consent UI
auth --> bff : callback code
bff --> auth : /token\ncode exchange
bff --> auth : /userinfo
bff --> clientdb : upsert user\nissuer + sub
bff --> user : app session cookie

auth --> authdb
auth --> redis

@enduml
```

## Notes

- クライアント DB には AuthFoundation のパスワードを持たない。
- クライアント側の主キーは `issuer + sub` を基準にする。
- Confidential client の `client_secret` は browser に置かず、BFF / backend 側で保持する。
- SPA 単体構成にする場合は public client + PKCE とし、DB は API backend 側に持たせる。
