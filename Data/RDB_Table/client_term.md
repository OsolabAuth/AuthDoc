# クライアント適用規約
物理名: `client_term`

## テーブル概要

クライアントごとに表示・同意対象とする規約を管理する。規約ID、バージョン、表示先URL、必須/任意の制御に利用する。

## テーブル構造

| ColumnName | Null | Key | Type | Description |
| :--- | :---: | :--- | :--- | :--- |
| sequence_id | Not Null | Primary | bigint(identity) | サロゲートキー |
| client_id | Not Null | Foreign | varchar(32) | クライアント識別子 |
| term_id | Not Null | - | varchar(64) | 適用対象規約識別子 |
| term_version | Not Null | - | varchar(32) | 規約バージョン |
| term_url | Not Null | - | nvarchar(2048) | 規約表示URL |
| required | Not Null | - | tinyint | 0:任意,1:必須 |
| create_datetime | Not Null | - | datetime2(0) | レコード作成日時 |
| update_datetime | Not Null | - | datetime2(0) | レコード更新日時 |
| status | Not Null | - | tinyint | 状態 0:無効,1:有効 |

## 制約

| ConstraintName | Type | Columns | Description |
| :--- | :--- | :--- | :--- |
| PK_client_term | Primary Key | sequence_id | レコードを一意に識別する |
| FK_client_term_client_id | Foreign Key | client_id | `client_master.client_id` を参照する |
| UQ_client_term_client_id_term_id | Unique | client_id, term_id | 同一クライアントへの重複適用を防止する |

## API利用箇所

- [規約取得](../../API/GetTerm.md)
- [規約同意](../../API/PostTermConsent.md)

## 補足

- 規約本文は `term_url` の参照先で管理し、本テーブルはクライアントごとの適用設定を持つ。
