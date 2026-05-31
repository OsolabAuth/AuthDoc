# AI Agent Delegated Auth Flow

## 概要

AIエージェントが、人間ユーザーから委譲された範囲で短命tokenを取得する認証認可フロー。

通常の人間ユーザー向けAuthorization Code Flowとは分離する。AIエージェントは `/authorize` にリダイレクトされる主体ではなく、専用の `agent_id` / `agent_secret` で `/agent/token` を呼び出す。

画面表示はPortal側の責務とし、Auth backendには画面表示用endpointを追加しない。

## 登録・委譲フロー

```plantuml
@startuml
actor User
participant "Auth Portal" as Portal
box OsolabAuth #0000ff0f
    participant "auth.osolab-auth" as Auth
    database RDB
    database MDB
end box

== Agent登録 ==
User -> Portal : AIエージェント登録情報を入力
note right
    agent_name
    target client_id
    allowed scopes
    expires_at
end note

Portal -> Auth : POST(/mfa/email/start or /mfa/authenticator/verify)
group #PaleGreen 強化認可
    note over Auth,MDB
        1. AuthSessionIdを検証
        2. MFAを検証
        3. agent管理用の短命step-up grantを発行
    end note
end
Auth --> Portal : step_up_grant

Portal -> Auth : POST(/agent)
note right
    Header
        Cookie: AuthSessionId
        X-Step-Up-Grant: step_up_grant
    Body
        agent_name
end note

group #PaleGreen agent作成
    note over Auth,RDB
        1. owner userがactiveか確認
        2. agent_idを発行
        3. agent_masterをactiveで作成
        4. agent.createdを監査ログに記録
    end note
end

Auth --> Portal : agent_id

Portal -> Auth : POST(/agent/{agent_id}/secret)
note right
    Header
        Cookie: AuthSessionId
        X-Step-Up-Grant: step_up_grant
end note

group #PaleGreen secret発行
    note over Auth,RDB
        1. agent所有者を確認
        2. agent_secretを発行
        3. secret_hashのみ保存
        4. secretはレスポンスで一度だけ返す
        5. agent.secret_issuedを監査ログに記録
    end note
end

Auth --> Portal : agent_id, agent_secret

Portal -> Auth : POST(/agent/{agent_id}/delegations)
note right
    Header
        Cookie: AuthSessionId
        X-Step-Up-Grant: step_up_grant
    Body
        client_id
        scopes
        expires_at
end note

group #PaleGreen 委譲作成
    note over Auth,RDB
        1. client_idが有効か確認
        2. 要求scopeがAI許可scope内か確認
        3. owner userとagentの紐づきを確認
        4. agent_delegationを作成
        5. agent.delegation_createdを監査ログに記録
    end note
end

Auth --> Portal : delegation_id, scopes, expires_at
User <-- Portal : agent_id / agent_secretを一度だけ表示
@enduml
```

## Token発行フロー

```plantuml
@startuml
actor "AI Agent Runtime" as Agent
participant "Resource Client / MCP Client" as Client
box OsolabAuth #0000ff0f
    participant "auth.osolab-auth" as Auth
    database RDB
    database MDB
end box
participant "Resource API" as API

== Agent Token取得 ==
Agent -> Auth : POST(/agent/token)
note right
    Body
        agent_id
        agent_secret
        client_id
        scope
end note

group #PaleGreen agent認証・委譲検証
    note over Auth,RDB
        1. agent_idが存在しactiveか確認
        2. agent_secretをhash照合
        3. owner userがactiveか確認
        4. client_idに対する有効なdelegationを確認
        5. delegationが未失効かつ有効期限内か確認
        6. 要求scopeがdelegation scopeの部分集合か確認
        7. token発行失敗/成功を監査ログに記録
    end note
end

group #PaleGreen token発行
    note over Auth,MDB
        1. sub=agent_idでID Token / Access Tokenを発行
        2. owner_sub / delegation_id / principal_typeをclaimに含める
        3. jtiを付与し短命tokenとして保存または検証可能にする
        4. last_used_atを更新
    end note
end

Auth --> Agent : access_token, id_token, token_type, expires_in

== Resource利用 ==
Agent -> Client : tokenを設定してタスク実行
Client -> API : API request
note right
    Header
        Authorization: Bearer access_token
end note

group #PaleGreen Resource側認可
    note over API
        1. JWKSでtoken署名を検証
        2. principal_type=ai_agentを確認
        3. sub(agent)とowner_sub(user)を監査ログへ分離記録
        4. scopeに基づいて操作を許可
    end note
end

API --> Client : result
Client --> Agent : result
@enduml
```

## 失効・ローテーションフロー

```plantuml
@startuml
actor User
participant "Auth Portal" as Portal
box OsolabAuth #0000ff0f
    participant "auth.osolab-auth" as Auth
    database RDB
    database MDB
end box

== Delegation失効 ==
User -> Portal : 委譲を取り消す
Portal -> Auth : DELETE(/agent/{agent_id}/delegations/{delegation_id})
note right
    Header
        Cookie: AuthSessionId
        X-Step-Up-Grant: step_up_grant(optional)
end note

group #PaleGreen 委譲失効
    note over Auth,RDB
        1. agent所有者を確認
        2. delegationをrevokedに更新
        3. 関連tokenを失効対象にする
        4. agent.delegation_revokedを監査ログに記録
    end note
end

Auth --> Portal : revoked

== Secretローテーション ==
User -> Portal : agent_secretを再発行
Portal -> Auth : POST(/agent/{agent_id}/secret)

group #PaleGreen secret再発行
    note over Auth,RDB
        1. step-up grantを検証
        2. 新しいagent_secretを発行
        3. secret_hashを差し替え
        4. 旧secretを利用不能にする
        5. agent.secret_rotatedを監査ログに記録
    end note
end

Auth --> Portal : new agent_secret(one-time)
@enduml
```

## 認可判断

Resource側は次のclaimを見て、人間ユーザー操作とAIエージェント操作を分離する。

| claim | 用途 |
| :--- | :--- |
| `sub` | 操作主体。AIエージェントの場合は `agent_id` |
| `principal_type` | `user` または `ai_agent` |
| `owner_sub` | AIエージェントの代理元ユーザー |
| `delegation_id` | どの委譲に基づく操作か |
| `scope` | 許可操作 |

監査ログでは、最低限以下を記録する。

- actor: `sub`
- actor_type: `principal_type`
- owner: `owner_sub`
- delegation_id
- client_id
- scope
- resource
- result

## Phase 2以降

- 高リスク操作の都度承認
- Manual Agent Pairing Flow
- Device Agent Pairing Flow
- Token Exchange互換grant
- DPoP / JWK bound token
- refresh token rotation
