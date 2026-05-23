# 認証基盤のCookie設計

## Cookie一覧

| Cookie名 | 用途 | 主な設定値 | 備考 |
| :--- | :--- | :--- | :--- |
| `AuthSessionId` | ログインセッション管理 | `HttpOnly`, `Secure`, `SameSite=Lax`, `Path=/` | ログイン成功時に払い出す |
| `AuthRequestSessionId` | 認可セッション管理 | `HttpOnly`, `Secure`, `SameSite=Lax`, `Path=/` | `/authorize` で認可セッション発行時に払い出す |
| `session_id` | 互換セッションCookie | `HttpOnly`, `Secure`, `SameSite=Lax`, `Path=/` | 互換のため併用。実装側では `AuthRequestSessionId` / `AuthSessionId` の代替として参照する |

## 運用方針

- 認可セッションIDは URL query や `localStorage` に保持しない。
- 規約取得 (`POST /terms/list`)、規約同意 (`POST /terms`)、ログイン (`POST /login`)、新規登録 (`POST /signup/email`) は Cookie の `AuthRequestSessionId`（互換で `session_id`）を利用して認可セッションを特定する。
- ログアウト時は `AuthSessionId`、`AuthRequestSessionId`、`session_id` を削除する。
