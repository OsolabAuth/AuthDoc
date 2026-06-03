# ヘルスチェック設計

## 目的

Cloud Run、Docker、Cloudflare Tunnel、ローカル起動のどれでも、起動状態と依存先の準備状態を確認できるようにする。

## エンドポイント

- `/health/live`: プロセスが応答できることを返す。
- `/health/ready`: 依存先を確認し、利用可能状態を返す。

## 運用方針

liveは軽量に保ち、readyでDBなどの依存先確認を行う。
