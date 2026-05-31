# クライアント登録画面設計

## ■ 目的

認証基盤へ OAuth クライアントを登録するための管理画面を定義する。  
登録時に `Public` / `Confidential` を選択でき、OAuth 2.1 前提で PKCE 必須、`redirect_uri` 完全一致運用の設定を行う。  
`InnerClient` は IdP 直轄の内部専用クライアントであるため、本画面の選択対象外とする。

## ■ 画面概要

| 項目 | 内容 |
| :--- | :--- |
| 画面名 | クライアント登録画面 |
| 画面ID | SCR-CLIENT-REGISTER-01 |
| 表示契機 | 管理者または開発者が新規クライアントを登録する場合 |
| 初期表示API | `GET /client/register` |
| 送信API | `POST /client/register` |
| 主目的 | クライアント種別、`redirect_uri`、scope、属性キーを登録する |

## ■ ワイヤーフレーム

<div style="max-width: 720px; margin: 24px auto; padding: 24px; border: 1px solid;">
  <div style="display: inline-block; padding: 3px 8px; margin-bottom: 16px; border: 1px solid;">SCR-CLIENT-REGISTER-01</div>
  <div style="margin-bottom: 8px;">LBL01: クライアント登録</div>
  <div style="margin-bottom: 20px;">MSG01: OAuthクライアント情報を入力してください</div>
  <div style="margin-bottom: 16px;">
    <div style="margin-bottom: 6px;">TXT01: クライアント名</div>
    <div style="padding: 14px 16px; border: 1px solid;">入力欄</div>
  </div>
  <div style="margin-bottom: 16px;">
    <div style="margin-bottom: 6px;">RAD01: クライアント種別</div>
    <div style="padding: 12px 14px; border: 1px solid;">○ Public　○ Confidential</div>
  </div>
  <div style="margin-bottom: 16px;">
    <div style="margin-bottom: 6px;">TXT02..n: Redirect URI 一覧</div>
    <div style="padding: 14px 16px; border: 1px solid;">入力欄</div>
    <div style="margin-top: 8px; padding: 10px 12px; border: 1px dashed;">BTN02: Redirect URI追加</div>
  </div>
  <div style="margin-bottom: 16px;">
    <div style="margin-bottom: 6px;">CHK01..n: 利用scope</div>
    <div style="padding: 12px 14px; border: 1px solid;">選択欄</div>
  </div>
  <div style="margin-bottom: 16px;">
    <div style="margin-bottom: 6px;">CHK11..n: 利用属性キー</div>
    <div style="padding: 12px 14px; border: 1px solid;">選択欄</div>
  </div>
  <div style="margin-bottom: 14px; padding: 12px 14px; border: 1px solid;">MSG02: 入力/登録エラー表示領域</div>
  <div style="margin-bottom: 16px; text-align: center;">
    <div style="display: inline-block; min-width: 220px; padding: 14px 24px; border: 1px solid;">BTN01: 登録</div>
  </div>
</div>

| レイアウトメモ | 内容 |
| :--- | :--- |
| 画面構成 | 単一カラムの入力フォーム |
| 種別選択 | クライアント名の直下に配置 |
| redirect_uri | 複数行登録を前提に追加ボタン付きで配置 |
| エラー表示 | 送信ボタンの直上に集約 |

## ■ 要素一覧

| 要素ID | 要素名 | 種別 | 必須 | 説明 |
| :--- | :--- | :--- | :---: | :--- |
| LBL01 | タイトル | Label | - | 画面の名称 |
| MSG01 | 説明文 | Label | - | 入力目的を示す補足文 |
| TXT01 | クライアント名 | TextBox | ○ | `client_master.client_name` |
| RAD01 | クライアント種別 | Radio | ○ | `Public` / `Confidential` を選択 |
| TXT02..n | Redirect URI | TextBox | ○ | `client_redirect_uri.redirect_uri` |
| BTN02 | Redirect URI追加 | Button | - | URI入力欄を追加する |
| CHK01..n | 利用scope | CheckBox | ○ | `client_scope.scope` を選択する |
| CHK11..n | 利用属性キー | CheckBox | - | `client_data_key.data_key` を選択する |
| MSG02 | エラー表示領域 | Message Area | - | 入力不備や登録失敗を表示する |
| BTN01 | 登録 | Button | ○ | 入力値を送信する |

## ■ 入力仕様

| 項目 | 要素ID | 形式 | バリデーション | 備考 |
| :--- | :--- | :--- | :--- | :--- |
| client_name | TXT01 | String | 1文字以上64文字以下 | 表示名として利用 |
| client_type | RAD01 | Enum | `Public` / `Confidential` | DB上は `0` / `1`。`InnerClient(99)` は本画面対象外 |
| redirect_uri | TXT02..n | URI | `https` または `http://localhost` | 登録時から完全一致運用前提 |
| scope | CHK01..n | String[] | 1件以上選択 | 利用可能な scope に限定。`Public` 選択時は `confidential_only=1` を選択不可 |
| data_key | CHK11..n | String[] | 任意 | 利用可能な属性キーに限定 |

## ■ イベント一覧

| イベントID | 要素ID | イベント | 条件 | 処理内容 | 結果 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| EV01 | BTN02 | クリック | なし | Redirect URI入力欄を1つ追加 | `TXT02..n` が増える |
| EV02 | RAD01 | 値変更 | `Public` 選択 | `confidential_only=1` の scope をグレーアウトし未選択化 | Publicで選択不可になる |
| EV03 | TXT02..n | フォーカスアウト | 入力あり | URI形式を検証 | 不正時は MSG02 に表示 |
| EV04 | BTN01 | クリック | 必須項目未入力 | 未入力チェック | エラーを表示し送信しない |
| EV05 | BTN01 | クリック | URI重複あり | 同一URI重複チェック | エラーを表示し送信しない |
| EV06 | BTN01 | クリック | Publicで confidential_only scope 選択あり | scope制約チェック | エラーを表示し送信しない |
| EV07 | BTN01 | クリック | 入力正常 | `POST /client/register` を実行 | 応答待ち中は二重送信不可 |
| EV08 | BTN01 | API成功 | `client_type=Public` | `client_id` を表示 | 登録完了 |
| EV09 | BTN01 | API成功 | `client_type=Confidential` | `client_id` と `client_secret` を表示 | 登録完了 |
| EV10 | BTN01 | API失敗 | `result=error` | `message` を MSG02 に表示 | 再入力可能 |

## ■ API送信仕様

### Request

| 項目 | 設定値 |
| :--- | :--- |
| Method | `POST` |
| Path | `/client/register` |
| Header | `Content-Type: application/json` |
| Body | `client_name`, `client_type`, `redirect_uris[]`, `scopes[]`, `data_keys[]` |

### Response

| 条件 | 処理 |
| :--- | :--- |
| Public 登録成功 | `client_id` を表示 |
| Confidential 登録成功 | `client_id` と `client_secret` を表示 |
| 登録失敗 | `message` を画面表示 |

## ■ 画面遷移

| 遷移元 | 条件 | 遷移先 |
| :--- | :--- | :--- |
| クライアント一覧 | 新規登録押下 | 本画面 |
| 本画面 | 登録成功 | クライアント詳細画面または完了ダイアログ |

## ■ 補足

- OAuth 2.1 前提として、登録種別に関わらず PKCE は必須である。
- `redirect_uri` は登録済み値との完全一致比較を前提とするため、曖昧一致やワイルドカードは許可しない。
- `scope_master.confidential_only=1` の scope は `Public` 選択時にグレーアウト表示し、API側でも登録拒否する。
- `Confidential` 選択時のみ、登録完了後に `client_secret` を一度だけ表示する運用が望ましい。
- `InnerClient` の作成・更新は内部管理APIまたは初期データ管理で実施し、本画面からは操作させない。
