---

description: サインアップ用メール認証コードを検証する

---

# サインアップ認証コード検証 <!-- omit in toc -->

## 1. API概要

サインアップセッションに保存された認証コードとリクエストの認証コードを照合し、メールアドレス確認済み状態に更新する。

### 1.1. リクエスト

#### 1.1.1. エンドポイント

``` text
POST /signup/verify
```

#### 1.1.2. リクエストヘッダ

| # | 物理名 | 論理名 | 型 | サイズ | 必須 | フォーマット | 補足事項 |
| --: | :-- | -- | -- | --: | :--: | -- | -- |
| 1. | Content-Type | コンテンツタイプ | string | - | ○ | - | `application/x-www-form-urlencoded` |
| 2. | Cookie | サインアップセッションCookie | string | - | - | - | `signup_session_id` |
| 3. | x-signup-session-id | サインアップセッションID | string | 32 | - | `^[A-Fa-f0-9]{32}$` | Cookieの代替 |

#### 1.1.3. リクエストパラメータ

| # | 物理名 | 論理名 | 型 | サイズ | 必須 | フォーマット | 補足事項 |
| --: | :-- | -- | -- | --: | :--: | -- | -- |
| 1. | signup_session_id | サインアップセッションID | string | 32 | - | `^[A-Fa-f0-9]{32}$` | Cookie/ヘッダー未指定時は必須 |
| 2. | code | 認証コード | string | 5 | ○ | `^[0-9]{5}$` | メール送信された認証コード |

### 1.2. レスポンス

#### 1.2.1. レスポンスヘッダ

| # | 物理名 | 論理名 | 型 | サイズ | 必須 | フォーマット | 補足事項 |
| --: | :-- | -- | -- | --: | :--: | -- | -- |
| 1. | Content-Type | コンテンツタイプ | string | - | ○ | - | `application/json` |

#### 1.2.2. レスポンスパラメータ

| # | 物理名 | 論理名 | 型 | サイズ | 必須 | フォーマット | 補足事項 |
| --: | :-- | -- | -- | --: | :--: | -- | -- |
| 1. | StatusCode | ステータスコード | string | 5 | ○ | `^[0-9]{5}$` | 正常時 `00000` |
| 2. | Message | メッセージ | string | - | ○ | - | 正常時は空文字 |

## 2. API詳細

### 2.1. 処理内容

| # | 処理概要 | 補足事項 |
| --: | -- | -- |
| 1. | リクエストパラメータ確認 | サインアップセッションIDと認証コードを検証 |
| 2. | サインアップセッション取得 | Redisからセッションを取得 |
| 3. | 認証コード照合 | 保存済みコードとリクエストコードを完全一致で比較 |
| 4. | 検証済み更新 | `Verified=true` としてRedisへ保存 |

### 2.2. シーケンス

```plantuml
@startuml
participant UI
box "AuthFoundation" #FAEBD7
  participant API as SignupVerifyController
  database Redis
end box

UI -> API : POST /signup/verify
API -> API : 入力検証
API -> Redis : SignupSession取得
API -> API : 認証コード照合
API -> Redis : Verified=true保存
API -> UI : 200 StatusCode=00000

alt エラー
  API -> UI : error, error_code, error_description
end
@enduml
```

### 2.3. エラーコード

| HTTPレスポンス | error | error_code | error_description |
| -- | -- | -- | -- |
| 400 | invalid_request | 00001 | リクエストパラメータエラー |
| 500 | server_error | 90000 | サーバーで予期しないエラーが発生しました |
