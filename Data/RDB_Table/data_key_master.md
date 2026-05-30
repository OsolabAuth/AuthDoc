# 属性キー管理マスタ
物理名: `data_key_master`

## テーブル概要

ユーザー属性として扱うキー定義を管理する。`user_info` に保存する属性名の正規化、およびクライアントごとの利用可能属性制御に使用する。

## テーブル構造

| ColumnName | Null | Key | Type | Description |
| :--- | :---: | :--- | :--- | :--- |
| data_key | Not Null | Primary | varchar(64) | 属性キー |
| create_datetime | Not Null | - | datetime2(0) | レコード作成日時 |
| update_datetime | Not Null | - | datetime2(0) | レコード更新日時 |

## 制約

| ConstraintName | Type | Columns | Description |
| :--- | :--- | :--- | :--- |
| PK_data_key_master | Primary Key | data_key | 属性キーを一意に識別する |

## 参照関係

| RelatedTable | Type | Description |
| :--- | :--- | :--- |
| [client_data_key](./client_data_key.md) | Referenced | クライアントごとの利用可能属性キー管理で参照される |

## 初期データ

`Auth/SQL/001_add_default_data.sql` で以下のOpenID Connect系属性キーを投入する。

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

- 現時点では属性キーの説明列や表示順列は持たない。必要なメタ情報は別設計で拡張する想定。
