# JWK鍵管理設計

## ■ 概要

OIDC の ID トークン署名で使用する RSA 鍵を RDB で永続管理する。  
公開鍵は `GET /jwks` で配布し、秘密鍵は環境変数キーを使って暗号化した状態でのみ保存する。

## ■ 対象コンポーネント

| コンポーネント | 役割 |
| :--- | :--- |
| `auth.jwk_master` | JWK公開情報と暗号化済み秘密鍵を保持 |
| `OidcSigningService` | 鍵の初期化、IDトークン署名、JWKs応答生成 |
| `AppConfig` | `JwkPrivateKeyEncryptionKey` の読み込み |

## ■ 鍵ライフサイクル

1. `OidcSigningService` 初回利用時に `auth.jwk_master` から `status=1` の鍵を取得する。  
2. 有効鍵が存在しない場合は RSA 2048 鍵を新規生成し、秘密鍵を暗号化して `auth.jwk_master` に登録する。  
3. トークン署名は更新日時が最新の有効鍵を使用する。  
4. `GET /jwks` は有効状態の公開鍵一覧を返却する。  

## ■ 秘密鍵暗号化仕様

| 項目 | 仕様 |
| :--- | :--- |
| 入力キー | 環境変数 `JwkPrivateKeyEncryptionKey` |
| キー導出 | UTF-8文字列を SHA-256 ハッシュ化し 256bit 鍵化 |
| 暗号方式 | AES-GCM |
| Nonce長 | 12 bytes |
| Tag長 | 16 bytes |
| 保存先 | `private_key_ciphertext`, `private_key_iv`, `private_key_tag` |

## ■ 運用注意

- `JwkPrivateKeyEncryptionKey` を変更すると既存秘密鍵を復号できないため、変更時は鍵再発行計画を含めて実施する。  
- 鍵ローテーション時は新鍵を `status=1` で追加後、既存IDトークンの有効期限経過を待って旧鍵を `status=0` に変更する。  
- 暗号化キーは Secret Manager 等で保護し、Git 管理や平文共有を禁止する。  
