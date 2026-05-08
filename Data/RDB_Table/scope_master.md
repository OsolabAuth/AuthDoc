# Scope管理マスタ
物理名: `scope_master`

## テーブル概要

認可要求で使用可能な scope を管理する。OpenID Connect 標準 scope と独自 scope の両方を登録対象とする。

## テーブル構造

| ColumnName | Null | Key | Type | Description |
| :--- | :---: | :--- | :--- | :--- |
| scope | Not Null | Primary | varchar(64) | scope識別子 |
| description | Not Null | - | nvarchar(255) | 説明文 |
| confidential_only | Not Null | - | tinyint | 0:全クライアント可,1:Confidentialのみ可 |
| create_datetime | Not Null | - | datetime2(0) | レコード作成日時 |
| update_datetime | Not Null | - | datetime2(0) | レコード更新日時 |
| status | Not Null | - | tinyint | 状態 0:無効,1:有効 |

## 制約

| ConstraintName | Type | Columns | Description |
| :--- | :--- | :--- | :--- |
| PK_scope_master | Primary Key | scope | scopeを一意に識別する |

## API利用箇所

- [認可エンドポイント](../../API/GetAuthorize.md)
- [規約取得](../../API/GetTerm.md)
- [トークンエンドポイント](../../API/PostToken.md)

## 補足

- 初期データとして少なくとも `openid`、`email`、`profile` を保持する想定。
- `confidential_only=1` の scope は `client_type=1` の Confidential Client と `client_type=99` の InnerClient にのみ登録可能とする。
- クライアント登録画面では `client_type=Public` 選択時に該当 scope をグレーアウト表示し、登録APIでも同一制約を検証する。
