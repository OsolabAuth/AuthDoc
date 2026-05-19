# 認証基盤のCookie設計

## Cookie一覧

| Cookie名 | 用途 | 主な設定値 | 備考 |
| :--- | :--- | :--- | :--- |
| `AuthSessionId` | ログインセッション管理 | `HttpOnly`, `Secure`, `SameSite=Lax`, `Path=/` | ログイン成功時に払い出す |
| `session_id` | 認可セッション管理 | `HttpOnly`, `Secure`, `SameSite=Lax`, `Path=/` | `/authorize` で認可セッション発行時に払い出す |

## 運用方針

- `session_id` は URL query や `localStorage` に保持しない。
- 規約取得 (`POST /terms/list`)、規約同意 (`POST /terms`)、ログイン (`POST /login`)、新規登録 (`POST /signup/account`) は Cookie の `session_id` を利用して認可セッションを特定する。
- ログアウト時は `AuthSessionId` と `session_id` を削除する。
