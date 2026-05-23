# GCP デプロイ構成

AuthFoundation を GCP に移行した後の初期構成です。
Cloud Run はアプリコンテナ、Compute Engine VM は SQL Server / Redis のデータ層として扱います。

```plantuml
@startuml
title AuthFoundation GCP Deployment

skinparam componentStyle rectangle
skinparam shadowing false

actor "User / Browser" as user

cloud "Cloudflare DNS\nosolab-auth.jp" as cloudflare

node "Google Cloud\nproject: osolab" as gcp {
  cloud "Cloud Run\nregion: us-west1" as cloudrun {
    component "authfoundation-api\nASP.NET Core / port 8080" as authapi
    component "oidc-sample-client\nnginx static UI / port 80" as sampleui
    component "osolab-inner-client-ui\nnginx static UI / port 80" as innerui
  }

  database "Artifact Registry\nrepo: auth\nregion: us-west1" as registry

  cloud "Secret Manager" as secrets {
    component "auth-db-connection" as secdb
    component "auth-redis-connection" as secred
    component "auth-password-hash-key" as sechash
    component "auth-jwk-encryption-key" as secjwk
    component "auth-mail-from-email" as secmailfrom
    component "auth-gmail-smtp-username" as secgmailuser
    component "auth-gmail-smtp-app-password" as secgmailpass
  }

  node "VPC: default\nsubnet: default" as vpc {
    node "Compute Engine VM\nauthfoundation-db" as vm {
      database "SQL Server\nDatabase: OsolabAuth\nPort: 1433" as sql
      database "Redis\nPort: 6379" as redis
    }
  }
}

cloud "GitHub Actions" as gha

user --> cloudflare : HTTPS
cloudflare --> authapi : auth.osolab-auth.jp

gha --> registry : docker push
gha --> authapi : gcloud run deploy
gha --> sampleui : gcloud run deploy
gha --> innerui : gcloud run deploy

authapi --> secdb : read
authapi --> secred : read
authapi --> sechash : read
authapi --> secjwk : read
authapi --> secmailfrom : read
authapi --> secgmailuser : read
authapi --> secgmailpass : read

authapi --> sql : private IP / TCP 1433
authapi --> redis : private IP / TCP 6379

sampleui ..> authapi : OIDC endpoints\nplanned
innerui ..> authapi : inner APIs\nplanned

@enduml
```

## Notes

- Cloud Run と Artifact Registry は `us-west1` に揃える。
- SQL Server / Redis は VM 上で手動運用する。
- Cloud Run から VM へは Direct VPC egress で private IP 接続する。
- GitHub Actions の GCP 認証は Workload Identity Federation を使い、JSON key は使わない。
- Cloudflare は DNS / optional proxy として使う。証明書発行までは `DNS only` を基本にする。
- メール送信は Gmail SMTP を利用し、`Mail__FromEmail` / `GmailSmtp__Username` / `GmailSmtp__AppPassword` を Secret Manager で注入する。
- `JwkPrivateKeyEncryptionKey` は `auth-jwk-encryption-key` から注入し、未設定時は起動失敗になる。
- deploy workflow では `CLOUD_RUN_UPDATE_SECRETS` の必須マッピングを検証し、`CLOUD_RUN_SECRET_MAX_AGE_DAYS` を設定した場合は古すぎる Secret version を検知して deploy を失敗させる。
