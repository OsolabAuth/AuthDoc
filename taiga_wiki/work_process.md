# AuthFoundation 作業プロセス

このページは、AuthFoundation / AuthPortal / AuthDoc の作業を進めるときの標準フローを定義する。

目的は、機能追加のたびに「設計だけある」「実装だけある」「テストだけ後から思い出す」状態を避け、レビューしやすい単位で積み上げること。

## 基本方針

- 1機能につき、Taigaチケットを1つ作る。
- 作業は必ず「設計 → API仕様 → 実装 → API Testerシナリオ → テスト → PR更新」の順に進める。
- Sequenceを正とする。API仕様、実装、API Testerシナリオは、最新Sequenceに合わせる。
- backend APIには画面表示エンドポイントを含めない。画面表示はPortal側の責務とする。
- 機能ごとにブランチを分ける。
- PRは小さく、レビューしやすい単位にする。
- stacked PRの場合、各PRのbaseを前段ブランチにし、PR単位で1コミット差分になるようにする。

## Taigaチケット構成

機能チケットには、最低限以下を記載する。

```markdown
# 目的

この機能で解決したいこと。

# 対象リポジトリ

- AuthFoundation
- AuthPortal
- AuthDoc

# 作業タスク

## 設計
- [ ] Sequenceを追加または更新する
- [ ] Architectureを追加または更新する
- [ ] 画面責務とbackend API責務を分離する
- PR:
- 説明:

## API仕様
- [ ] API/*.mdをSequenceに合わせる
- [ ] Request / Response / Errorを定義する
- [ ] 画面表示用endpointが混ざっていないことを確認する
- PR:
- 説明:

## 実装
- [ ] backend実装
- [ ] portal実装が必要な場合は別PRで対応する
- [ ] DB/Redis/設定変更を明記する
- PR:
- 説明:

## API Tester
- [ ] api_tester/*.jsonを追加または更新する
- [ ] 対象Sequenceと同じ順序でscenarioを作る
- [ ] 前段requestのresponseを後段requestへ渡す
- PR:
- 説明:

## テスト
- [ ] unit test
- [ ] integration test
- [ ] API Tester手動実行
- [ ] GitHub Actions確認
- PR:
- 説明:

# レビュー観点

- SequenceとAPI仕様が一致しているか
- API仕様と実装が一致しているか
- API Testerが機能の主要経路を確認できるか
- 認証/認可/監査ログ/失効の観点が抜けていないか
```

## 作業フロー

### 1. チケット作成

最初にTaigaへ機能チケットを作る。

チケット名は以下の形式にする。

```text
[Auth] 機能名
```

例:

```text
[Auth] AI Agent Delegated Auth
[Auth] MFA / Step-up Authorization
[Auth] Password Reset
```

### 2. 設計ブランチを作る

設計はAuthDocから始める。

```text
codex/design-<feature-name>
```

設計PRでは、主に以下を更新する。

- `Sequence/*.md`
- `Architecture/**/*.md`
- 必要に応じて `ScreenDesign/*.md`

Sequenceには、backend内部の細かいDB操作を全部描かない。`AuthorizationCodeFlow.md` と同じ粒度で、公開エンドポイントと内部処理noteを中心にする。

### 3. API仕様ブランチを作る

設計PRをbaseにして、API仕様PRを作る。

```text
codex/design-<feature-name>-apis
```

API仕様PRでは、主に以下を更新する。

- `API/*.md`
- `SUMMARY.md`

API仕様は必ずSequenceに合わせる。

画面表示はPortal側の責務なので、backend APIに以下のような画面表示endpointを追加しない。

```text
GET /login
GET /signup
GET /terms/view
```

backend APIは、データ取得、状態変更、token発行、認可判断などに限定する。

### 4. 実装ブランチを作る

API仕様PRをbaseにして、実装PRを作る。

```text
codex/implement-<feature-name>
```

実装では、以下を確認する。

- API仕様とrouteが一致しているか
- Request / Response / ErrorがAPI仕様と一致しているか
- 認証/認可チェックがあるか
- 監査ログが必要なイベントに入っているか
- secretやtokenをログ出力していないか
- 失効/期限切れの処理があるか

### 5. API Testerブランチを作る

実装PRをbaseにして、API Tester PRを作る。

```text
codex/test-<feature-name>-api-tester
```

API Testerは、最新Sequenceの順序に合わせる。

```text
Sequence
  ↓
API仕様
  ↓
実装
  ↓
api_tester scenario
```

シナリオでは、前段requestのresponse bodyを後段requestに渡す。

例:

```text
${getEntityById("request-id")."response"."body"."access_token"}
```

環境変数は `api_tester/README.md` に記載する。

### 6. テスト

最低限、以下を確認する。

```text
dotnet build
dotnet test
npm run summary
API Tester import JSONのJSON構文チェック
必要に応じてAPI Tester手動実行
```

ローカルサーバが起動していないなど、実API実行できない場合はPR本文に明記する。

### 7. PR更新

Taigaチケットの各タスクにPRリンクと説明を記載する。

```markdown
## 設計
PR: https://github.com/...
説明: SequenceとArchitectureを追加。

## API仕様
PR: https://github.com/...
説明: API/*.mdを追加。

## 実装
PR: https://github.com/...
説明: backend実装を追加。

## API Tester
PR: https://github.com/...
説明: Sequenceに合わせたシナリオを追加。

## テスト
PR: https://github.com/...
説明: dotnet test / API Tester確認結果。
```

## コミット形式

コミットメッセージは以下の形式に統一する。

```text
## Taiga #<チケット番号> <対応内容を簡潔に>

* 対応内容1
* 対応内容2
```

例:

```text
## Taiga #46 AI Agent Delegated Auth認証フローを設計

* agent登録・委譲・token発行・失効のシーケンスを追加
* agent token claimとAPI境界を整理
```

## ブランチとPRの積み方

機能を段階的に確認したい場合は、stacked PRにする。

```text
main
  └─ codex/design-feature
       └─ codex/design-feature-apis
            └─ codex/implement-feature
                 └─ codex/test-feature-api-tester
```

各PRのbaseは前段ブランチにする。

```text
codex/design-feature          -> base: main
codex/design-feature-apis     -> base: codex/design-feature
codex/implement-feature       -> base: codex/design-feature-apis
codex/test-feature-api-tester -> base: codex/implement-feature
```

この形にすると、各PRの差分がその作業だけになり、レビューしやすい。

## レビュー前チェックリスト

PRを出す前に確認する。

- [ ] Taigaチケット番号がコミットメッセージに入っている
- [ ] PR本文に目的、内容、確認結果がある
- [ ] SequenceとAPI仕様が矛盾していない
- [ ] backend APIに画面表示endpointが混ざっていない
- [ ] API Testerが最新Sequenceの順序に合っている
- [ ] secret/token/passwordをPR本文やログに貼っていない
- [ ] 実行できなかったテストがあれば理由を書いている

## 例外

緊急修正や小さな文言修正では、設計PRを省略してよい。

ただし、以下に該当する場合は必ず標準フローに戻す。

- 認証方式が変わる
- 認可判断が変わる
- token claimが変わる
- DB/Redis構造が変わる
- APIのRequest / Responseが変わる
- API Testerの主要シナリオが変わる
