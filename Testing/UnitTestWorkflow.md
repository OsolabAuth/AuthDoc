# 単体テスト・カバレッジ運用ルール

## 目的

AuthFoundation の機能追加では、設計書に書いたインターフェース、レスポンスコード、正常系、主要な異常系をテストで確認する。
また、追加した本体コードの line coverage / branch coverage は 100% を目標ではなく必須条件として扱う。

## 必須ルール

1. 本番コードにテスト用データやテスト専用分岐を埋め込まない。
2. 単体テストで使うユーザー、クライアント、同意、委譲などのデータは、テストごとに登録する。
3. DB を使うテストでは、`TestInitialize` またはテスト内 setup で必要なレコードを作り、`TestCleanup` または `finally` で逆順に削除する。
4. DB cleanup は外部キー順を意識し、子テーブルから親テーブルへ削除する。
5. 共有の固定ユーザーや固定セッションに依存しない。必要なID、メールアドレス、subject はテストケースごとに用意する。
6. InMemory store は純粋なユニットテスト用に限定する。DB 永続化の仕様確認を InMemory だけで代替しない。
7. すべての test method には XML summary を付け、目的、入力値、期待値が分かるようにする。
8. PR description には、単体テスト GitHub Actions の実行URLとカバレッジ結果を貼る。

## 参考にするテスト形

既存サンプルの `sample/autmb-Authentication-and-Member/AuthFoundation.Tests/PostLoginTest.cs` と同じ考え方を採用する。

- `TestInitialize` で環境変数、DB、Redis を初期化する。
- テストに必要な `user`、`user_info`、`client` などをテスト側で登録する。
- Redis や DB の副作用はテスト内または cleanup で消す。
- production code 側に「テストを通すための初期ユーザー」や「テスト環境だけの認証ショートカット」を置かない。

## テストデータ管理

### InMemory store の場合

InMemory store はテストごとに新しいインスタンスを作る。
必要なユーザーや委譲データは、各テストまたはテスト専用 helper で明示的に作成する。

例:

```csharp
var users = new InMemoryUserStore();
users.CreateUser(
    "login-flow@example.com",
    "Passw0rd!",
    "Login User",
    new DateOnly(2000, 1, 1),
    "login_user");
```

### DB store の場合

DB store を対象にするテストでは、テストごとに一意なキーを使って登録し、必ず cleanup する。

例:

```csharp
[TestInitialize]
public void TestInitialize()
{
    InitDb();
    RegisterTestUser(_email, _subject);
    RegisterTestClient(_clientId, _redirectUri);
}

[TestCleanup]
public void TestCleanup()
{
    DeleteUserConsent(_subject);
    DeleteUserInfo(_subject);
    DeleteUser(_subject);
    DeleteClient(_clientId);
}
```

cleanup は成功時だけでなく失敗時にも実行されるようにする。
複数テスト間で同じDBデータを使い回さない。

## 網羅対象

設計書にインターフェースを追加したら、最低限以下をテストする。

- 必須パラメータ不足
- フォーマット不正
- 認証失敗
- 認可失敗
- 正常レスポンス
- response_code / error_code / error / error_description
- DB 更新がある場合は更新後状態
- DB 更新失敗系がある場合はロールバックまたは未更新状態

## カバレッジ確認

AuthFoundation では GitHub Actions の単体テスト workflow で cobertura を出力する。
ローカル確認では以下を使う。

```powershell
dotnet test --project AuthFoundationTest\AuthFoundationTest.csproj -c Debug --no-restore -- --coverage --coverage-output coverage.cobertura.xml --coverage-output-format cobertura
```

判定基準:

- line-rate = 1
- branch-rate = 1
- 追加コードの未カバー行なし
- 追加コードの未カバー分岐なし

## PR に貼る内容

PR description には以下を書く。

```text
## テスト

- GitHub Actions: <run URL>
- Coverage: line-rate=1 / branch-rate=1
- 設計書の正常系、主要異常系、レスポンスコードを確認済み
```
