# ログアウトフロー

## ■ フロー概要
Auth Session / Access Token / ID Token失効フロー

## ■ シーケンス

```plantuml
@startuml
actor User
participant Client
participant "AuthFoundation" as auth
database rdb
database mdb

User -> Client : ログアウト開始

group ログアウトエンドポイント
    Client -> auth : POST(/Logout)
    note right
        Header
            Cookie.session_id : ログインセッションID
            Authorization: Bearer アクセストークン(任意)
            Content-Type : application/x-www-form-urlencoded
        Body
            logout_all=false
    end note

    auth -> auth : CookieからセッションIDを取得

    group ログインセッション確認
        opt Cookie.session_idが存在する場合
            auth -> mdb : Get:DB1
            note right
                key: Cookie.session_id
            end note
            auth <-- mdb : ログインセッション情報
        end
    end

    alt ログインセッションが有効な場合

        group ログインセッション削除
            auth -> mdb : Delete:DB1
            note right
                key: Cookie.session_id
            end note
            auth <-- mdb
        end

        group Cookie削除
            auth -> auth : Cookie.session_idを削除
        end

        opt Authorizationヘッダーが存在する場合
            auth -> auth : Bearerアクセストークンからtoken_id抽出

            group アクセストークン取得
                auth -> mdb : Get:DB3
                note right
                    key: token_id
                end note
                auth <-- mdb : アクセストークン情報
            end

            group アクセストークン削除
                auth -> mdb : Delete:DB3
                note right
                    key: token_id
                end note
                auth <-- mdb
            end
        end

        group IDトークン失効登録
            note over auth,mdb
                jtiをブラックリスト登録
            end note
            auth -> mdb : Set:DB8
            note right
                Key
                    id_token_jti
                Value
                    jti
                    osolab_id
                    revoked_at: 現在時刻
                    expires_at: id_token.expまで
                    reason: logout
            end note
            auth <-- mdb
        end

        alt logout_all = true の場合

            group 全セッション失効日時登録
                auth -> mdb : Set:DB9
                note right
                    Key
                        osolab_id
                    Value
                        revoked_after: 現在時刻
                        reason: logout_all
                end note
                auth <-- mdb
            end

            note over auth,mdb
                user単位で全Auth Session / Access Token / ID Tokenを無効化
            end note

        end

        User <- auth : ログアウト完了画面 or Clientへリダイレクト

    else ログインセッションなしの場合

        User <- auth : 既にログアウト済みレスポンス

    end

end

group RP側後処理(任意)
    Client -> Client : ローカルセッション削除
    Client -> Client : 自前Cookie削除
    Client -> Client : ログイン画面へ遷移
end

@enduml
```
