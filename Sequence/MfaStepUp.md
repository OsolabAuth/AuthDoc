# MFA / Step-up Authorization Flow

## 概要

メールコードまたはAuthenticatorアプリで多要素認証を行い、退会・パスワード変更などの高リスク操作に必要な短命の強化認可状態を発行する。

## シーケンス

```plantuml
@startuml
actor User
participant Client
box OsolabAuth #0000ff0f
    participant "auth.osolab-auth" as Auth
    database RDB
    database MDB
end box
participant "MailProvider" as Mail

== MFA開始 ==
User -> Client : 高リスク操作を開始
Client -> Auth : POST(/mfa/email/start)
note right
    Header
        Cookie: AuthSessionId
    Body
        purpose: password_change / withdrawal
end note

group #PaleGreen MFA開始処理
    note over Auth,MDB
        1. AuthSessionId とユーザー状態を確認
        2. purpose がstep-up対象か確認
        3. email MFA sessionを発行
        4. 確認コードをメール送信
    end note
end

Auth -> Mail : send MFA code
Mail --> User : MFA code
Auth --> Client : challenge started

== MFA検証 ==
User -> Client : MFA codeを入力
Client -> Auth : POST(/mfa/email/verify)
note right
    Header
        Cookie: AuthSessionId
    Body
        code
        purpose
end note

group #PaleGreen 強化認可発行
    note over Auth,MDB
        1. MFA session と code を検証
        2. 失敗回数・有効期限を確認
        3. purpose固定のstep-up grantを5分程度で発行
        4. 監査ログ対象イベントとして記録
    end note
end

Auth --> Client : step_up_grant

== 高リスク操作 ==
Client -> Auth : POST(high-risk API)
note right
    Header
        Cookie: AuthSessionId
        X-Step-Up-Grant: step_up_grant
end note

group #PaleGreen 強化認可検証
    note over Auth,MDB
        1. AuthSessionId とstep-up grantを照合
        2. grantのpurpose / expires_at / consumed状態を確認
        3. API実行後に必要に応じてgrantを消費済みにする
    end note
end

Auth --> Client : operation result

== Authenticator登録/検証 ==
Client -> Auth : POST(/mfa/authenticator/setup)
Auth --> Client : otp_auth_url / recovery info
Client -> Auth : POST(/mfa/authenticator/verify)
group #PaleGreen TOTP検証
    note over Auth,RDB
        1. TOTP secretを一時発行
        2. 初回codeを検証
        3. 有効化済みMFAとして保存
    end note
end
Auth --> Client : authenticator enabled
@enduml
```

## 注意点

- 通常ログインセッションとstep-up grantは別に管理する。
- step-up grantはpurposeを固定し、短命にする。
- 失敗回数制限と監査ログを前提にする。
