# POST /mfa/email/verify

メールで受け取った認証コードを検証する。

## Request

- code: メール認証コード

## Response

検証成功時、短時間のstep-up状態を発行する。
