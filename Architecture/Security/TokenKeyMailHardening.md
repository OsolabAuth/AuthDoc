# Token / Key / Mail Hardening

## 目的

レビューで見つかった以下の本番運用上の穴をまとめて閉じる。

- OIDC ID Token の署名鍵がプロセス起動ごとに生成され、JWKS と既発行 token の検証が不安定になる。
- AI Agent 用 `access_token` をJWT化すると、既存方針であるRedis管理の不透明トークンとずれる。
- token endpoint の成功レスポンスに `Cache-Control: no-store` がない。
- メールMFAコードはAPIレスポンスから消えたが、メール送信IFがなく実ユーザーへ届かない。
- メールMFAコード、step-up token、agent secret 検証に試行回数制限がない。

## 方針

### 署名鍵

OIDC署名鍵は `SigningKeyProvider` に分離する。

初期実装ではRSA秘密鍵PEMと `kid` を設定から読み込む。

```text
SigningKey:KeyId
SigningKey:PrivateKeyPem
```

`OidcTokenService` は起動時生成鍵を持たず、DIされた `SigningKeyProvider` で署名とJWKS出力を行う。

設定が不足している場合は fail closed とし、token発行/JWKS生成を行わない。

開発環境では `appsettings.Development.json` に開発用の固定鍵を置く。これは本番用途では使わない。

### Agent Token

AI Agent 用 `access_token` はJWTにしない。

ID Token と Access Token は用途を分ける。ID Token は署名付きJWTとしてAgentの代理主体情報を表現し、Access Token はRedis管理へ移行しやすい不透明トークンとして発行する。

```text
id_token:
  aud = client_id
  principal_type = ai_agent
  agent_id
  agent_name
  owner_sub
  delegation_id
  scope

access_token:
  agt_{random}
  stored fields:
    principal_type = ai_agent
    subject = agent_id
    owner_sub
    delegation_id
    scope
    expires_at
```

初期実装ではインメモリstoreに保存し、将来Redisへ置き換える。

### Token Response Cache Header

以下のtoken発行成功レスポンスに必ず付与する。

```http
Cache-Control: no-store
Pragma: no-cache
```

対象:

- `POST /token`
- `POST /agent/token`

### メール送信IF

メールMFAコード送信を `IEmailSender` に分離する。

初期実装では2種類を用意する。

```text
IEmailSender
  DevelopmentEmailSender
  RecordingEmailSender for unit tests
```

`DevelopmentEmailSender` は本番メール送信ではなく、ログへ送信イベントを記録する開発用実装とする。

本番ではSMTP/API送信実装を追加する前提で、APIレスポンスにコードは返さない。

### 試行回数制限

インメモリの最小実装として `AttemptLimiter` を追加する。

制限対象:

- email MFA verify
- step-up token validate
- agent secret validate

初期値:

```text
max_attempts = 5
window = 5 minutes
```

超過時は `unauthorized` を返す。

本番DB/Redis移行時はIP、user、agent、client単位のキー設計へ置き換える。

## API影響

### POST /mfa/email/start

レスポンス形は維持する。

```json
{
  "result": "challenge_created",
  "delivery": "email",
  "email": "user@example.com",
  "expires_at": "2026-06-02T00:00:00Z"
}
```

内部で `IEmailSender.SendMfaCode` を呼ぶ。

### POST /token

成功時にcache禁止ヘッダを付ける。

### POST /agent/token

成功時にcache禁止ヘッダを付ける。

`access_token` は `agt_...` の不透明トークンとして返し、Agentの主体情報はstore側に保存する。

## テスト観点

- JWKS の `kid` が設定値と一致する。
- ID Token のheader `kid` とJWKSの `kid` が一致する。
- ID Token の署名が設定鍵の公開鍵で検証できる。
- Agent ID Token がJWTで、`principal_type`、`owner_sub`、`delegation_id`、`scope` を含む。
- Agent Access Token が `agt_...` の不透明トークンで、store上に `principal_type`、`owner_sub`、`delegation_id`、`scope` を保持する。
- `/token` 成功時に `Cache-Control: no-store` と `Pragma: no-cache` が付く。
- `/agent/token` 成功時に `Cache-Control: no-store` と `Pragma: no-cache` が付く。
- `/mfa/email/start` は `IEmailSender` を呼ぶが、レスポンスにcodeを含めない。
- email MFA verify の失敗回数が上限を超えると以後拒否する。
- agent secret の失敗回数が上限を超えると以後拒否する。

## 初期実装範囲

- AuthFoundation のインメモリ実装を対象にする。
- 外部メール送信API、KMS連携、Redis rate limit は今回含めない。
- API Testerはメール送信の実配送がないため、Unit Testで保証する。
