# POST /password/reset

メールコード、生年月日、新しいパスワードを検証し、パスワードを再設定する。

## Request

`Content-Type: application/json`

```json
{
  "email": "user@example.com",
  "birth_date": "1990-01-01",
  "email_code": "123456",
  "new_password": "Newpass1!"
}
```

| name | required | description |
|---|---:|---|
| `email` | yes | ログインメールアドレス |
| `birth_date` | yes | 登録済み生年月日。`yyyy-MM-dd` |
| `email_code` | yes | `POST /password/reset/start` により送信された6桁コード |
| `new_password` | yes | 新しいパスワード。8文字以上、英大文字、英小文字、数字を含む |

## Response

```json
{
  "result": "password_reset"
}
```

## Error

| status | error | description |
|---:|---|---|
| 400 | `invalid_request` | 入力形式が不正 |
| 400 | `invalid_request` | 新しいパスワードがポリシーを満たさない |
| 401 | `invalid_token` | メールコード、生年月日、またはユーザー状態が一致しない |

## Notes

- メールコードは成功時に消費される。
- パスワード更新前にメールコードと生年月日を再検証する。
- パスワードリセット後の既存セッションやリフレッシュトークン失効は、トークン失効設計に従う。
