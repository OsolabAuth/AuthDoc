# AuthDoc

OsolabAuth / AuthFoundation の設計書、API仕様、運用ドキュメントを管理するリポジトリです。

この `main` ブランチは、既存ドキュメントを機能単位で整理し直すための最小起点です。現行ドキュメントは `legacy/current` ブランチに保持しています。

## Rebuild Policy

AuthFoundation / AuthPortal の移植PRに合わせて、次の単位で設計書を追加します。

1. 共通処理系
2. 最低限の OIDC flow
3. OIDC metadata / JWKS / UserInfo
4. signup / profile
5. terms / consent
6. logout / revoke
7. MFA / step-up authorization
8. password and account lifecycle
9. AI Agent Delegated Auth

## Branch Preview

`Deploy selected docs branch to Pages` workflowを手動実行すると、指定したAuthDocブランチをGitHub Pagesへ公開できます。

1. GitHub Actionsで `Deploy selected docs branch to Pages` を開く。
2. `Run workflow` から公開したい `ref` を指定する。
3. 通常は `run_summary=false`、`render_plantuml=false` のまま実行する。

`render_plantuml=false` では既存PlantUMLをtextコードブロックとして表示します。レビュー時に本文を確認する用途ではこの設定を使います。
