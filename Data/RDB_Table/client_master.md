# クライアントマスタ
物理名: `client_master`

## テーブル概要

認証基盤を利用するクライアントアプリケーションを管理する。認可要求時のクライアント存在確認、およびトークン発行時のクライアント認証で使用する。  
`client_type=99` の `InnerClient` は IdP 直轄クライアントを表し、認証基盤内の信頼済みクライアントとしてフルアクセス可能な種別とする。

## テーブル構造

| ColumnName | Null | Key | Type | Description |
| :--- | :---: | :--- | :--- | :--- |
| client_id | Not Null | Primary | varchar(32) | クライアント識別子 |
| client_name | Not Null | - | nvarchar(64) | クライアント表示名 |
| client_secret | Not Null | - | varchar(64) | クライアントシークレット |
| client_type | Not Null | - | tinyint | 0:Public,1:Confidential,99:InnerClient |
| create_datetime | Not Null | - | datetime2(0) | レコード作成日時 |
| update_datetime | Not Null | - | datetime2(0) | レコード更新日時 |
| status | Not Null | - | tinyint | 状態 0:無効,1:有効 |

## 制約

| ConstraintName | Type | Columns | Description |
| :--- | :--- | :--- | :--- |
| PK_client_master | Primary Key | client_id | クライアントを一意に識別する |

## 参照関係

| RelatedTable | Type | Description |
| :--- | :--- | :--- |
| [user_info](./user_info.md) | Referenced | ユーザー属性のクライアント単位管理で参照される |
| [client_data_key](./client_data_key.md) | Referenced | クライアントごとの利用可能属性キー管理で参照される |

## 初期データ

`Auth/SQL/001_add_default_data.sql` で、認証基盤自身を示すクライアントとして以下を投入する。

| client_id | client_name | status |
| :--- | :--- | :---: |
| 00000000000000000000000000000000 | OsolabAuth | 1 |

この初期クライアントは `client_type=99` の `InnerClient` として扱う前提とする。

## API利用箇所

- [認可エンドポイント](../../API/GetAuthorize.md)
- [新規登録](../../API/signup.md)
- [トークンエンドポイント](../../API/PostToken.md)

## 補足

- 現実装では `Helper.CertClient` により存在確認のみ実施している。
- `status` の有効判定は今後の認可・トークン発行処理で利用する前提の設計となる。
- `InnerClient` は通常の外部クライアント登録画面からは作成せず、初期データ投入または内部管理APIのみで登録する。
- `InnerClient` は `client_scope` や `client_data_key` の通常制限を受けず、全scope・全属性へのアクセスを許可できる特権クライアントとして扱う。

## 仕様実装上の不足項目

| 不足項目 | 理由 |
| :--- | :--- |
| `redirect_uri` 登録情報 | 複数URIの許可管理が必要であり、本テーブル単独では表現できない |
| クライアント種別ごとの詳細ポリシー | `InnerClient` を含む種別ごとの差分を `client_type` だけでは表現しきれない |
| トークン認証方式 | `client_secret_basic` / `none` の許可方式を管理できない |
| PKCE必須設定 | クライアント別に `code_challenge` 必須かどうかを制御できない |
