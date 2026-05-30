# GET /health/live, GET /health/ready

AuthFoundation の稼働確認に使う。

## GET /health/live

プロセスが応答できる場合に正常応答を返す。

## GET /health/ready

依存先確認結果を含めて準備状態を返す。
