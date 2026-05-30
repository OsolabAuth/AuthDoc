# 規約マスタ（廃止）
物理名: `term_master`

## テーブル概要

旧設計で利用規約本文と版管理を保持するために定義していたテーブル。  
現行実装（`Auth/SQL/000_init_db.sql`）では `client_term.term_url` 参照に移行しており、本テーブルは作成しない。

## テーブル構造

| ColumnName | Null | Key | Type | Description |
| :--- | :---: | :--- | :--- | :--- |
| term_id | Not Null | Primary | varchar(64) | 規約識別子 |
| term_type | Not Null | - | varchar(32) | 規約種別 |
| title | Not Null | - | nvarchar(255) | 規約名 |
| version | Not Null | - | varchar(32) | 規約バージョン |
| content | Not Null | - | nvarchar(max) | 規約本文 |
| effective_start_datetime | Not Null | - | datetime2(0) | 適用開始日時 |
| effective_end_datetime | Null | - | datetime2(0) | 適用終了日時 |
| create_datetime | Not Null | - | datetime2(0) | レコード作成日時 |
| update_datetime | Not Null | - | datetime2(0) | レコード更新日時 |
| status | Not Null | - | tinyint | 状態 0:無効,1:有効 |

## 制約

| ConstraintName | Type | Columns | Description |
| :--- | :--- | :--- | :--- |
| PK_term_master | Primary Key | term_id | 規約識別子を一意に識別する |
| UQ_term_master_term_type_version | Unique | term_type, version | 同種規約のバージョン重複を防止する |

## API利用箇所

- なし（現行実装では未使用）

## 補足

- 互換性確保のために削除SQLでは `DROP TABLE IF EXISTS [auth].[term_master]` を実行対象に含める。
