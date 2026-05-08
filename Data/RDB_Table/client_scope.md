# クライアント許可Scope
物理名: `client_scope`

## テーブル概要

クライアントごとに要求可能な scope を管理する。規約画面での表示対象や認可時の scope 検証で使用する。

## テーブル構造

| ColumnName | Null | Key | Type | Description |
|:---|:---:|:---|:---|:---|
| sequence_id | Not Null | Primary | bigint(identity) | サロゲートキー |
| client_id | Not Null | Foreign | varchar(32) | クライアント識別子 |
| scope | Not Null | Foreign | varchar(64) | 許可するscope |
| required | Not Null | - | tinyint | 0:任意,1:必須 |
| create_datetime | Not Null | - | datetime2(0) | レコード作成日時 |
| update_datetime | Not Null | - | datetime2(0) | レコード更新日時 |
| status | Not Null | - | tinyint | 状態 0:無効,1:有効 |

## 制約

| ConstraintName | Type | Columns | Description |
|:---|:---|:---|:---|
| PK_client_scope | Primary Key | sequence_id | レコードを一意に識別する |
| FK_client_scope_client_id | Foreign Key | client_id | `client_master.client_id` を参照する |
| FK_client_scope_scope | Foreign Key | scope | `scope_master.scope` を参照する |
| UQ_client_scope_client_id_scope | Unique | client_id, scope | 同一クライアントへの重複scope登録を防止する |

## API利用箇所

- [認可エンドポイント](../../API/GetAuthorize.md)
- [規約取得](../../API/GetTerm.md)

## 補足

- `required=1` の scope は認可時に自動付与または拒否不可の扱いを取れる。
