# API Tester scenarios

Talend API Tester向けのimport JSONを置く。

## authfoundation_local_debug.json

AuthFoundationのローカル起動確認用シナリオ。

### Environment

| variable | default | description |
| :--- | :--- | :--- |
| `AuthServer` | `http://localhost:5000` | AuthFoundation backend |
| `email` | `demo@example.com` | 開発用ユーザー |
| `clientId` | `00000000000000000000000000000000` | 開発用client |
| `agentName` | `Issue Triage Agent` | 作成するagent名 |
| `agentScope` | `openid profile` | 現行実装で通るagent scope |
| `agentExpiresDays` | `7` | agent delegation有効日数 |

### Scenarios

- `01. Local smoke`
  - `/version`
  - `/health/live`
  - `/health/ready`
  - `/.well-known/openid-configuration`
  - `/jwks`
  - `/terms/current`
- `02. MFA to agent token`
  - `/mfa/email/start`
  - `/mfa/email/verify`
  - `/agent`
  - `/agent/token`
  - `/audit/logs`

### Notes

- 参照元JSONと同じく、前段requestのresponse bodyを `getEntityById(...).response.body...` で後段requestに渡す。
- 現行実装の `/agent` は agent作成、secret発行、delegation作成をまとめて行うため、このシナリオも現行APIに合わせている。
- 設計上の `/agent/{agent_id}/secret` や `/agent/{agent_id}/delegations` は、実装後に別シナリオとして追加する。
