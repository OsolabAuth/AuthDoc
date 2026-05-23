---

description: 新規登録画面を表示する

---

# 新規登録画面表示 <!-- omit in toc -->

## 1. API概要

メールアドレス送信、認証コード検証、パスワード登録を行う新規登録画面を表示する。認可セッションIDはURLクエリではなくCookieで引き継ぐ。

### 1.1. リクエスト

#### 1.1.1. エンドポイント

``` text
GET /signup
```

#### 1.1.2. リクエストヘッダ

| # | 物理名 | 論理名 | 型 | サイズ | 必須 | フォーマット | 補足事項 |
| --: | :-- | -- | -- | --: | :--: | -- | -- |
| 1. | Cookie | 認可セッションCookie | string | - | - | - | `AuthRequestSessionId` または `session_id` |

#### 1.1.3. リクエストパラメータ

なし

### 1.2. レスポンス

#### 1.2.1. レスポンスヘッダ

| # | 物理名 | 論理名 | 型 | サイズ | 必須 | フォーマット | 補足事項 |
| --: | :-- | -- | -- | --: | :--: | -- | -- |
| 1. | Content-Type | コンテンツタイプ | string | - | ○ | - | `text/html; charset=UTF-8` |

#### 1.2.2. レスポンスパラメータ

HTMLを返却する。

| # | 物理名 | 論理名 | 型 | サイズ | 必須 | フォーマット | 補足事項 |
| --: | :-- | -- | -- | --: | :--: | -- | -- |
| 1. | email form | メール送信フォーム | html | - | ○ | - | `POST /signup/email` を実行 |
| 2. | code form | 認証コード検証フォーム | html | - | ○ | - | `POST /signup/verify` を実行 |
| 3. | password form | パスワード登録フォーム | html | - | ○ | - | `POST /signup/account` を実行 |

## 2. API詳細

### 2.1. 処理内容

| # | 処理概要 | 補足事項 |
| --: | -- | -- |
| 1. | 画面表示 | 新規登録用の3段階フォームを表示 |
| 2. | メール送信 | メールアドレス入力後 `POST /signup/email` を実行 |
| 3. | 認証コード検証 | メール認証コード入力後 `POST /signup/verify` を実行 |
| 4. | 本登録 | パスワード入力後 `POST /signup/account` を実行 |

### 2.2. シーケンス

```plantuml
@startuml
participant Browser
participant UI as Auth UI

Browser -> UI : GET /signup
UI -> Browser : 200 HTML
Browser -> UI : POST /signup/email
Browser -> UI : POST /signup/verify
Browser -> UI : POST /signup/account
@enduml
```

### 2.3. エラーコード

| HTTPレスポンス | error | error_code | error_description |
| -- | -- | -- | -- |
| 500 | server_error | 90000 | サーバーで予期しないエラーが発生しました |
