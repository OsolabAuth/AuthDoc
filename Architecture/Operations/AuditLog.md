# 監査ログ設計

## 目的

認証、アカウント操作、MFA、AIエージェント操作を後から確認できるようにする。

## 記録対象

- signup
- login / logout
- token revoke
- MFA / step-up
- password change / reset
- withdrawal
- agent created / token issued

## 初期実装

開発確認用のインメモリ監査ログとして実装し、永続化は後続課題とする。
