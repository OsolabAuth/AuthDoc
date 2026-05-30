# POST /account/password

ログイン済みユーザーのパスワードを変更する。

## Request

- current_password: 現在のパスワード
- new_password: 新しいパスワード

## Authorization

MFA後のstep-up状態を必須にする。
