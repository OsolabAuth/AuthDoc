# Docs Portal アクセス制御構成

HonKit は静的サイト生成ツールなので、認証・認可は別アプリで担当する。
将来的には Markdown を直接読む Docs Portal を Cloud Run に置き、AuthFoundation OIDC でログインさせる。

```plantuml
@startuml
title Docs Portal Access Control

skinparam componentStyle rectangle
skinparam shadowing false

actor "Anonymous User" as anon
actor "Logged-in User" as login
actor "Internal User" as internal

node "Git repository\nauthfoundation-docs" as repo {
  folder "Markdown" as markdown {
    component "API / Interface\nvisibility: public" as publicdocs
    component "Architecture / Data\nvisibility: internal" as internaldocs
  }
}

cloud "Cloud Run" as cloudrun {
  component "docs-portal\nASP.NET Core + Markdig" as portal
  component "authfoundation-api\nOIDC Provider" as auth
}

database "Docs session store\ncookie / Redis optional" as session

anon --> portal : GET /docs/api
portal --> publicdocs : render public markdown
portal --> anon : public HTML

anon --> portal : GET /docs/architecture
portal --> auth : OIDC redirect
auth --> login : login UI
auth --> portal : callback + id_token
portal --> session : create session

login --> portal : GET /docs/architecture
portal --> portal : check role / email allowlist
portal --> login : 403 if not internal

internal --> portal : GET /docs/architecture
portal --> internaldocs : render internal markdown
portal --> internal : internal HTML

@enduml
```

## Access model

```text
visibility: public
  未ログインでも閲覧可

visibility: authenticated
  ログイン済みなら閲覧可

visibility: internal
  internal role / email allowlist のみ閲覧可
```

## Notes

- 内部資料を 1 つの静的 HonKit build に含め、JavaScript で隠すだけの方式は使わない。
- 公開用 build と内部用 build を分けるか、Docs Portal で Markdown front matter を見て出し分ける。
- 初期実装は email allowlist でよい。後から `role=internal` claim へ移行する。
