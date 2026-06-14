# API Tester Scenario Design

## 目的

AuthFoundation の主要なAPIフローを Talend API Tester 互換のシナリオJSONとして管理する。

機能追加時は、対応する Sequence 設計と同じ単位で API Tester シナリオを追加し、手動結合確認でも同じ手順を再現できるようにする。

## 配置

AuthFoundation リポジトリに `APITester/` フォルダを作成し、主要フローごとにJSONを配置する。

例:

- `APITester/AuthorizationCodeFlow.json`
- `APITester/MfaStepUp.json`
- `APITester/PasswordAccountFlow.json`
- `APITester/AgentDelegatedAuth.json`

## 命名規則

Project名:

```text
AuthFoundation - <Sequence名>
```

Scenario名:

```text
<Sequence名>
```

Request名:

```text
01. <操作内容>
02. <操作内容>
03. <操作内容>
```

## 環境変数

最低限、以下を定義する。

- `AuthServer`
- `ClientId`
- `RedirectUri`
- `Scope`
- `Email`
- `Password`
- `BirthDate`
- `NewPassword`
- `StepUpToken`
- `AgentName`
- `AgentId`
- `AgentSecret`
- `AgentScope`

秘密情報は `private: true` にする。

## 前のレスポンス参照

前のリクエストのレスポンス値は Talend API Tester の参照式を使う。

例:

```text
${"AuthFoundation - AuthorizationCodeFlow"."01. Start authorize request"."response"."body"."response_code"}
```

Cookieやレスポンスボディから後続リクエストに値を渡す場合は、環境変数への手入力ではなく、可能な限り参照式を使う。

## 初期対象フロー

### AuthorizationCodeFlow

目的:

- `/authorize`
- `/login`
- `/token`

を一連の認可コードフローとして確認する。

### MfaStepUp

目的:

- `/mfa/email/start`
- `/mfa/email/verify`
- `/mfa/authenticator/setup`
- `/mfa/authenticator/verify`

を確認する。

### PasswordAccountFlow

目的:

- `/password/reset`
- `/account/password`
- `/account/withdrawal`

を確認する。

`/account/password` と `/account/withdrawal` は強化認可トークンを前提にする。

### AgentDelegatedAuth

目的:

- `/agent`
- `/agent/token`
- `/agent/{agent_id}/secret`
- `/agent/{agent_id}/revoke`

を確認する。

Agent作成とSecret再発行、失効は強化認可トークンを前提にする。

## テスト観点

- JSONとして構文エラーがない
- Talend API Testerにインポートできる形式である
- 各シナリオが複数Requestを含む
- 後続Requestが前段レスポンス参照式を使う
- production環境では秘密情報が `private: true` になっている

