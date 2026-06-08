# POST /password/reset

Resets a forgotten password.

This endpoint requires both registered birth date verification and possession of the login email address through an email verification code.

## Request

```http
POST /password/reset
Content-Type: application/json
```

```json
{
  "email": "user@example.com",
  "birth_date": "2000-01-02",
  "email_code": "123456",
  "new_password": "Newpass1!"
}
```

## Request Fields

| Field | Required | Description |
| --- | --- | --- |
| `email` | Yes | Login email address. |
| `birth_date` | Yes | Registered birth date in `yyyy-MM-dd` format. |
| `email_code` | Yes | Verification code sent to the login email address. |
| `new_password` | Yes | New password. Must satisfy the password policy. |

## Successful Response

```json
{
  "result": "password_reset"
}
```

## Error Responses

### Invalid Request

Returned when a required field is missing or malformed.

```json
{
  "response_code": "00001",
  "message": "email_code is required",
  "error": "invalid_request",
  "error_code": "00001",
  "error_description": "email_code is required"
}
```

### Unauthorized

Returned when the user does not exist, birth date does not match, or the email code is wrong or expired.

```json
{
  "response_code": "00008",
  "message": "unauthorized",
  "error": "invalid_token",
  "error_code": "00008",
  "error_description": "unauthorized"
}
```

### Too Many Requests

Returned when password reset verification fails repeatedly for the same login email address, IP address, or email challenge.

```json
{
  "response_code": "00010",
  "message": "too many requests",
  "error": "too_many_requests",
  "error_code": "00010",
  "error_description": "too many requests"
}
```

## Security Notes

- Password reset must not rely on birth date alone.
- The email code must be delivered to the login email address and must not be returned by `POST /mfa/email/start`.
- The email code must be verified before comparing `birth_date`.
- Repeated reset failures must be rate limited.
- The password must not be changed when birth date or email code verification fails.
