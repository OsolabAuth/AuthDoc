# クライアント属性許可テーブル
物理名: `client_data_key`

## テーブル概要

クライアントごとに取得・管理を許可する属性キーを定義する。`/userinfo` やIDトークンへ返却可能なクレーム制御の基礎データとなる。

## テーブル構造

| ColumnName | Null | Key | Type | Description |
|:---|:---:|:---|:---|:---|
| sequence_id | Not Null | Primary | bigint(identity) | サロゲートキー |
| client_id | Not Null | Foreign | varchar(32) | 対象クライアント識別子 |
| data_key | Not Null | Foreign | varchar(64) | クライアントで利用可能な属性キー |
| create_datetime | Not Null | - | datetime2(0) | レコード作成日時 |
| update_datetime | Not Null | - | datetime2(0) | レコード更新日時 |
| status | Not Null | - | tinyint | 状態 0:無効,1:有効 |

## 制約

| ConstraintName | Type | Columns | Description |
|:---|:---|:---|:---|
| PK_client_data_key | Primary Key | sequence_id | レコードを一意に識別する |
| FK_client_data_key_client_id | Foreign Key | client_id | `client_master.client_id` を参照する |
| FK_client_data_key_data_key | Foreign Key | data_key | `data_key_master.data_key` を参照する |

## インデックス

- Primary Key のみ

## 参照関係

| RelatedTable | Type | Description |
|:---|:---|:---|
| [client_master](./client_master.md) | References | 利用クライアントを参照する |
| [data_key_master](./data_key_master.md) | References | 属性キー定義を参照する |

## 初期データ

`Auth/SQL/001_add_default_data.sql` で、デフォルトクライアント `00000000000000000000000000000000` に対して以下の属性キーを有効登録する。

- `sub`
- `email`
- `name`
- `preferred_username`
- `latest_login_datetime`
- `email_verified`

## API利用箇所

- [UserInfoエンドポイント](../../API/GetUserinfo.md)
- [OpenID Configurationエンドポイント](../../API/GetWellKnown.md)

## 補足

- 現行ソースコードに直接の参照実装はないが、API設計書上のクレーム返却制御を成立させるためのマスタとしてDDLと初期データが存在する。
