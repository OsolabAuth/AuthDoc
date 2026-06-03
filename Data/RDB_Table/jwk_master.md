# JWK管理マスタ
物理名: `jwk_master`

## テーブル概要

OIDC の ID トークン署名に使用する鍵を管理する。  
公開鍵は JWK として配布し、秘密鍵は暗号化済みバイト列として保持する。

## テーブル構造

| ColumnName | Null | Key | Type | Description |
| :--- | :---: | :--- | :--- | :--- |
| sequence_id | Not Null | Primary | bigint identity | レコード識別子 |
| kid | Not Null | Unique | varchar(64) | 鍵識別子 |
| kty | Not Null | - | varchar(16) | 鍵種別。`RSA` |
| alg | Not Null | - | varchar(16) | 署名アルゴリズム。`RS256` |
| key_use | Not Null | - | varchar(16) | 鍵用途。`sig` |
| public_n | Not Null | - | varchar(512) | RSA 公開鍵 modulus (Base64Url) |
| public_e | Not Null | - | varchar(16) | RSA 公開鍵 exponent (Base64Url) |
| private_key_ciphertext | Not Null | - | varbinary(max) | AES-GCM 暗号化済み秘密鍵 |
| private_key_iv | Not Null | - | varbinary(12) | AES-GCM nonce |
| private_key_tag | Not Null | - | varbinary(16) | AES-GCM 認証タグ |
| create_datetime | Not Null | - | datetime2(0) | レコード作成日時 |
| update_datetime | Not Null | - | datetime2(0) | レコード更新日時 |
| status | Not Null | - | tinyint | 状態 0:無効,1:有効 |

## 制約

| ConstraintName | Type | Columns | Description |
| :--- | :--- | :--- | :--- |
| PK_jwk_master | Primary Key | sequence_id | レコードを一意に識別する |
| UQ_jwk_master_kid | Unique Index | kid | `kid` の重複を禁止する |
| IX_jwk_master_status_update_datetime | Index | status, update_datetime | 有効鍵の取得を高速化する |

## 参照関係

このテーブルは外部キー参照を持たない。

## 初期データ

初期SQLで固定データは投入しない。  
アプリ起動後、`OidcSigningService` が有効鍵不在時に1件目を自動生成する。

## API利用箇所

- [JWKsエンドポイント](../../API/GetJwks.md)
- [トークンエンドポイント](../../API/PostToken.md)

## 補足

- 秘密鍵暗号化キーは環境変数 `JwkPrivateKeyEncryptionKey` を利用する。
- 署名には `status=1` のうち `update_datetime` が最新の鍵を使用する。
