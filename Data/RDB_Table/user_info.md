# ユーザー属性テーブル
物理名: `user_info`

## テーブル概要

ユーザーに紐づく属性値をクライアント単位で保持する。`/userinfo` やIDトークン生成時に返却するクレーム情報の格納先となる。

## テーブル構造

| ColumnName | Null | Key | Type | Description |
|:---|:---:|:---|:---|:---|
| osolab_id | Not Null | Primary / Foreign | nvarchar(16) | ユーザー識別子 |
| client_id | Not Null | Primary / Foreign | varchar(32) | クライアント識別子 |
| data_key | Not Null | Primary | varchar(64) | 属性キー |
| data_value | Not Null | - | nvarchar(4000) | 属性値 |
| create_datetime | Not Null | - | datetime2(0) | レコード作成日時 |
| update_datetime | Not Null | - | datetime2(0) | レコード更新日時 |
| status | Not Null | - | tinyint | 状態 0:無効,1:有効 |

## 制約

| ConstraintName | Type | Columns | Description |
|:---|:---|:---|:---|
| PK_user_info | Primary Key | osolab_id, client_id, data_key | ユーザー・クライアント・属性キーの組を一意に識別する |
| FK_user_info_osolab_id | Foreign Key | osolab_id | `osolab_user.osolab_id` を参照する |
| FK_user_info_client_id | Foreign Key | client_id | `client_master.client_id` を参照する |

## インデックス

| IndexName | Columns | Description |
|:---|:---|:---|
| IX_user_info_osolab_id_client_id_data_key_status | osolab_id, client_id, data_key, status | 単一属性取得時の有効データ検索に使用する |
| IX_user_info_osolab_id_client_id_status | osolab_id, client_id, status | クライアント単位の属性一覧取得に使用する |
| IX_user_info_osolab_id_status | osolab_id, status | ユーザー単位の属性検索に使用する |

## 参照関係

| RelatedTable | Type | Description |
|:---|:---|:---|
| [osolab_user](./osolab_user.md) | References | 属性保有者のユーザーを参照する |
| [client_master](./client_master.md) | References | 属性提供元クライアントを参照する |

## API利用箇所

- [UserInfoエンドポイント](../../API/GetUserinfo.md)
- [トークンエンドポイント](../../API/PostToken.md)

## 補足

- `data_key` 自体には外部キー制約がなく、運用上は `data_key_master` と整合させる前提で使用する。
- `sub` や `email` のような標準クレームだけでなく、クライアント固有属性も `data_key` / `data_value` の組で保持できる設計となっている。

## 仕様実装上の不足項目

| 不足項目 | 理由 |
|:---|:---|
| scopeとの対応表 | `userinfo` で scope に応じた claim を返すためには `scope_data_key` が必要 |
| 共通属性の扱い定義 | アーキテクチャ資料では共通クライアント属性利用が示唆されており、運用ルールの明文化が必要 |
