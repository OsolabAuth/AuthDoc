# Unit Test Workflow Design

## 目的

AuthFoundation の main 向けPRでも単体テストとカバレッジを確認できるようにする。

リリース用workflowだけが存在する状態では、mainへ向かうPRで設計書のインターフェースやレスポンスコードを網羅しているか確認しにくい。そこで、main と `codex/**` ブランチを対象に単体テストworkflowを追加する。

## 対象

AuthFoundation リポジトリの GitHub Actions。

追加:

- `.github/workflows/unit-test-coverage.yml`

整理:

- `build-push-dispatch.yml` から `deploy/windows-home` push トリガーを削除する

## workflow仕様

### トリガー

- `pull_request`
- `push` to `main`
- `push` to `codex/**`
- `workflow_dispatch`

### 実行内容

1. Checkout
2. .NET SDK 10.0.x setup
3. `dotnet restore AuthFoundationTest/AuthFoundationTest.csproj`
4. `dotnet build AuthFoundation/AuthFoundation.csproj -c Debug --no-restore /p:UseSharedCompilation=false`
5. `dotnet test --project AuthFoundationTest/AuthFoundationTest.csproj -c Debug /p:UseSharedCompilation=false --coverage`
6. Coverage summary を GitHub Step Summary に出力
7. Cobertura XML を artifact としてアップロード

## カバレッジ基準

開発ルールとして、追加コードは以下を満たすこと。

- 設計書に記載したインターフェースをテストで網羅する
- レスポンスコード、正常系、主要異常系をテストで網羅する
- 追加した本体コードの line coverage / branch coverage は 100% を目標にする

## Windows deploy整理

AuthFoundation のリリース先は Cloud Run を正とする。

そのため、`deploy/windows-home` ブランチへの push をリリースworkflowのトリガーにしない。

## テスト観点

- workflow YAMLとして構文が成立する
- `pull_request` と `workflow_dispatch` が定義されている
- main / `codex/**` push が定義されている
- `dotnet test` の coverage オプションが定義されている
- `build-push-dispatch.yml` に `deploy/windows-home` が残っていない

