# Scope-Claimマッピング
物理名: `scope_data_key`

## テーブル概要

scope ごとに返却可能な claim を定義する。`/userinfo` や ID トークン生成時に、scope から返却対象 `data_key` を導出するために利用する。

## テーブル構造

| ColumnName | Null | Key | Type | Description |
| :--- | :---: | :--- | :--- | :--- |
| sequence_id | Not Null | Primary | bigint(identity) | サロゲートキー |
| scope | Not Null | Foreign | varchar(64) | 対象scope |
| data_key | Not Null | Foreign | varchar(64) | 返却対象claim |
| create_datetime | Not Null | - | datetime2(0) | レコード作成日時 |
| update_datetime | Not Null | - | datetime2(0) | レコード更新日時 |
| status | Not Null | - | tinyint | 状態 0:無効,1:有効 |

## 制約

| ConstraintName | Type | Columns | Description |
| :--- | :--- | :--- | :--- |
| PK_scope_data_key | Primary Key | sequence_id | レコードを一意に識別する |
| FK_scope_data_key_scope | Foreign Key | scope | `scope_master.scope` を参照する |
| FK_scope_data_key_data_key | Foreign Key | data_key | `data_key_master.data_key` を参照する |
| UQ_scope_data_key_scope_data_key | Unique | scope, data_key | 同一マッピングの重複登録を防止する |

## API利用箇所

- [UserInfoエンドポイント](../../API/GetUserinfo.md)
- [OpenID Configurationエンドポイント](../../API/GetWellKnown.md)

## 補足

- 例として `email -> email`、`profile -> name, preferred_username, picture` のような対応付けを行う。
