# POST /password/reset/start

パスワードリセット用のメールコード送信を開始する。

このAPIは、メールアドレスと生年月日が登録情報と一致する場合だけメールコードを送信する。ただし、アカウント有無や生年月日一致をレスポンスで露出しないため、不一致の場合も同じ成功レスポンスを返す。

## Request

`Content-Type: application/json`

```json
{
  "email": "user@example.com",
  "birth_date": "1990-01-01"
}
```

| name | required | description |
|---|---:|---|
| `email` | yes | ログインメールアドレス |
| `birth_date` | yes | 登録済み生年月日。`yyyy-MM-dd` |

## Response

```json
{
  "result": "reset_challenge_started",
  "delivery": "email"
}
```

## Error

| status | error | description |
|---:|---|---|
| 400 | `invalid_request` | メールアドレスまたは生年月日の形式が不正 |

## Notes

- レスポンスにはメールコードを含めない。
- メールアドレスが未登録、または生年月日が一致しない場合も `200 OK` を返す。
- 実際にメールが送信されたかどうかは外部に露出しない。
