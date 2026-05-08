# ユーザーScope同意履歴
物理名: `user_client_scope_consent`

## テーブル概要

ユーザーがクライアントごとに同意した scope を保持する。規約同意画面後の認可継続判定や、再認可の要否判定に利用する。

## テーブル構造

| ColumnName | Null | Key | Type | Description |
| :--- | :---: | :--- | :--- | :--- |
| sequence_id | Not Null | Primary | bigint(identity) | サロゲートキー |
| osolab_id | Not Null | Foreign | nvarchar(16) | ユーザー識別子 |
| client_id | Not Null | Foreign | varchar(32) | クライアント識別子 |
| scope | Not Null | Foreign | varchar(64) | 同意対象scope |
| consented_datetime | Not Null | - | datetime2(0) | 同意日時 |
| create_datetime | Not Null | - | datetime2(0) | レコード作成日時 |
| update_datetime | Not Null | - | datetime2(0) | レコード更新日時 |
| status | Not Null | - | tinyint | 状態 0:無効,1:有効 |

## 制約

| ConstraintName | Type | Columns | Description |
| :--- | :--- | :--- | :--- |
| PK_user_client_scope_consent | Primary Key | sequence_id | レコードを一意に識別する |
| FK_user_client_scope_consent_osolab_id | Foreign Key | osolab_id | `osolab_user.osolab_id` を参照する |
| FK_user_client_scope_consent_client_id | Foreign Key | client_id | `client_master.client_id` を参照する |
| FK_user_client_scope_consent_scope | Foreign Key | scope | `scope_master.scope` を参照する |
| UQ_user_client_scope_consent_osolab_id_client_id_scope | Unique | osolab_id, client_id, scope | 同一scopeの有効同意重複を防止する |

## API利用箇所

- [認可エンドポイント](../../API/GetAuthorize.md)
- [規約取得](../../API/GetTerm.md)
- [規約同意](../../API/PostTermConsent.md)

## 補足

- 履歴完全保持が必要な場合は、本テーブルを状態管理用にし、別途イベント履歴テーブルを追加してもよい。
