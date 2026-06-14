# ユーザーテーブル
物理名: `osolab_user`

## テーブル概要

認証基盤のユーザーアカウント本体を管理する。ログイン、メールアドレス重複チェック、仮登録から有効化までの状態管理で利用する。

## テーブル構造

| ColumnName | Null | Key | Type | Description |
| :--- | :---: | :--- | :--- | :--- |
| osolab_id | Not Null | Primary | nvarchar(16) | ユーザー識別子 |
| email | Not Null | - | varchar(255) | ログインIDとして利用するメールアドレス |
| password | Not Null | - | varchar(128) | パスワードハッシュ値 |
| nonce | Not Null | - | varchar(8) | パスワードハッシュ生成時に付与するノンス |
| create_datetime | Not Null | - | datetime2(0) | 会員登録日時 |
| update_datetime | Not Null | - | datetime2(0) | 会員情報更新日時 |
| status | Not Null | - | tinyint | 状態 0:無効,1:有効,2:仮登録 |

## 制約

| ConstraintName | Type | Columns | Description |
| :--- | :--- | :--- | :--- |
| PK_osolab_user | Primary Key | osolab_id | ユーザーを一意に識別する |

## インデックス

| IndexName | Columns | Description |
| :--- | :--- | :--- |
| IX_osolab_user_email | email | メールアドレスによるユーザー検索で使用する |

## 参照関係

| RelatedTable | Type | Description |
| :--- | :--- | :--- |
| [user_info](./user_info.md) | Referenced | ユーザー属性を管理する子テーブル |

## API利用箇所

- [新規登録](../../API/signup.md)
- [メール認証](../../API/GetSignupVerify.md)
- [認証基盤ログイン](../../API/PostLogin.md)

## 補足

- `osolab_id` は `TableHelper.CreateNewOsolabUser` で16桁の16進文字列として生成する。
- `password` はクライアントから受け取ったハッシュ済みパスワードに対し、`nonce` を付与してさらに HMAC-SHA256 を実施した結果を保存する。
- 現実装のメール重複チェックは `status = 1` のみを対象としているが、API設計書・アーキテクチャ資料上は仮登録を含めた重複排除を想定している。
