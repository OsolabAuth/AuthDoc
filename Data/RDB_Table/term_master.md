# 規約マスタ
物理名: `term_master`

## テーブル概要

利用規約、プライバシーポリシー等の規約本文と版管理を行う。クライアントごとにどの規約を提示するかは `client_term` で制御する。

## テーブル構造

| ColumnName | Null | Key | Type | Description |
|:---|:---:|:---|:---|:---|
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
|:---|:---|:---|:---|
| PK_term_master | Primary Key | term_id | 規約識別子を一意に識別する |
| UQ_term_master_term_type_version | Unique | term_type, version | 同種規約のバージョン重複を防止する |

## API利用箇所

- [規約取得](../../API/GetTerm.md)
- [規約同意](../../API/PostTermConsent.md)

## 補足

- `term_id` は版ごとに採番してもよいが、履歴追跡を簡潔にするには `term_type + version` 一意制約を併用する。
