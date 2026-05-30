# クライアントリダイレクトURI
物理名: `client_redirect_uri`

## テーブル概要

クライアントごとに許可する `redirect_uri` を複数登録する。`GET /authorize` と `POST /token` における `redirect_uri` 検証の基準データとなる。

## テーブル構造

| ColumnName | Null | Key | Type | Description |
| :--- | :---: | :--- | :--- | :--- |
| sequence_id | Not Null | Primary | bigint(identity) | サロゲートキー |
| client_id | Not Null | Foreign | varchar(32) | クライアント識別子 |
| redirect_uri | Not Null | - | nvarchar(2048) | 許可するリダイレクトURI |
| is_default | Not Null | - | tinyint | 0:通常,1:デフォルト |
| create_datetime | Not Null | - | datetime2(0) | レコード作成日時 |
| update_datetime | Not Null | - | datetime2(0) | レコード更新日時 |
| status | Not Null | - | tinyint | 状態 0:無効,1:有効 |

## 制約

| ConstraintName | Type | Columns | Description |
| :--- | :--- | :--- | :--- |
| PK_client_redirect_uri | Primary Key | sequence_id | レコードを一意に識別する |
| FK_client_redirect_uri_client_id | Foreign Key | client_id | `client_master.client_id` を参照する |
| UQ_client_redirect_uri_client_id_redirect_uri | Unique | client_id, redirect_uri | 同一クライアントへの重複登録を防止する |

## インデックス

| IndexName | Columns | Description |
| :--- | :--- | :--- |
| IX_client_redirect_uri_client_id_status | client_id, status | クライアント単位の有効URI検索で使用する |
| IX_client_redirect_uri_client_id_redirect_uri_status | client_id, redirect_uri, status | 認可時・トークン時の完全一致検証で使用する |

## API利用箇所

- [認可エンドポイント](../../API/GetAuthorize.md)
- [トークンエンドポイント](../../API/PostToken.md)

## 補足

- URI比較は前方一致ではなく完全一致を前提とする。
- `localhost` 用の開発URIも本テーブルへ明示登録する。
