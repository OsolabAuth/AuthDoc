# ユーザー規約同意履歴
物理名: `user_term_consent`

## テーブル概要

ユーザーがどのクライアントで、どの版の規約に、いつ同意または拒否したかを記録する監査用履歴テーブル。

## テーブル構造

| ColumnName | Null | Key | Type | Description |
|:---|:---:|:---|:---|:---|
| sequence_id | Not Null | Primary | bigint(identity) | サロゲートキー |
| osolab_id | Not Null | Foreign | nvarchar(16) | ユーザー識別子 |
| client_id | Not Null | Foreign | varchar(32) | クライアント識別子 |
| term_id | Not Null | Foreign | varchar(64) | 対象規約識別子 |
| term_version | Not Null | - | varchar(32) | 同意時点の規約バージョン |
| consent_result | Not Null | - | tinyint | 0:拒否,1:同意 |
| consented_datetime | Not Null | - | datetime2(0) | 同意・拒否日時 |
| create_datetime | Not Null | - | datetime2(0) | レコード作成日時 |

## 制約

| ConstraintName | Type | Columns | Description |
|:---|:---|:---|:---|
| PK_user_term_consent | Primary Key | sequence_id | レコードを一意に識別する |
| FK_user_term_consent_osolab_id | Foreign Key | osolab_id | `osolab_user.osolab_id` を参照する |
| FK_user_term_consent_client_id | Foreign Key | client_id | `client_master.client_id` を参照する |
| FK_user_term_consent_term_id | Foreign Key | term_id | `term_master.term_id` を参照する |

## インデックス

| IndexName | Columns | Description |
|:---|:---|:---|
| IX_user_term_consent_osolab_id_client_id_term_id_consented_datetime | osolab_id, client_id, term_id, consented_datetime | 最新同意状況の判定に使用する |

## API利用箇所

- [規約取得](../../API/GetTerm.md)
- [規約同意](../../API/PostTermConsent.md)
- [認可エンドポイント](../../API/GetAuthorize.md)

## 補足

- 最新状態の上書きではなく履歴で保存し、判定時に最新レコードを参照する。
