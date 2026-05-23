---

description: ログイン画面を表示する

---

# ログイン画面表示 <!-- omit in toc -->

## 1. API概要

認可フロー中のユーザーにメールアドレスとパスワードを入力するログイン画面を表示する。認可セッションIDはURLクエリではなくCookieで引き継ぐ。

### 1.1. リクエスト

#### 1.1.1. エンドポイント

``` text
GET /login
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
| 1. | email | メールアドレス入力欄 | html | - | ○ | - | `POST /login` の `email` として送信 |
| 2. | password | パスワード入力欄 | html | - | ○ | - | `POST /login` の `password` として送信 |
| 3. | signup link | 新規登録リンク | html | - | ○ | - | `/signup` へ遷移 |

## 2. API詳細

### 2.1. 処理内容

| # | 処理概要 | 補足事項 |
| --: | -- | -- |
| 1. | 画面表示 | ログインフォームを表示 |
| 2. | 認可セッション引き継ぎ | `AuthRequestSessionId` Cookieを使用し、URLにはセッションIDを表示しない |
| 3. | ログイン実行 | ログインボタン押下時に `POST /login` を実行 |
| 4. | 新規登録遷移 | 新規登録リンク押下時に `/signup` へ遷移 |

### 2.2. シーケンス

```plantuml
@startuml
participant Browser
participant UI as Auth UI

Browser -> UI : GET /login
UI -> Browser : 200 HTML
Browser -> UI : POST /login
@enduml
```

### 2.3. エラーコード

| HTTPレスポンス | error | error_code | error_description |
| -- | -- | -- | -- |
| 500 | server_error | 90000 | サーバーで予期しないエラーが発生しました |
