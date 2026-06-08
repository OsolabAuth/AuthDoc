# POST /mfa/authenticator/setup

Registers or rotates an authenticator app setup for a user.

This endpoint issues a TOTP secret, so it requires a recent step-up authorization.

## Request

```http
POST /mfa/authenticator/setup
Content-Type: application/json
```

```json
{
  "email": "user@example.com",
  "step_up_token": "sup_xxx"
}
```

## Request Fields

| Field | Required | Description |
| --- | --- | --- |
| `email` | Yes | Login email address of the user who owns the authenticator setup. |
| `step_up_token` | Yes | Step-up token issued by email MFA or authenticator MFA within the valid lifetime. |

## Successful Response

```json
{
  "email": "user@example.com",
  "secret": "BASE32SECRET",
  "otpauth_uri": "otpauth://totp/OsolabAuth:user@example.com?secret=BASE32SECRET&issuer=OsolabAuth&algorithm=SHA1&digits=6&period=30"
}
```

## Error Responses

### Invalid Request

Returned when `email` is missing or malformed, or `step_up_token` is missing.

```json
{
  "response_code": "00001",
  "message": "step_up_token is required",
  "error": "invalid_request",
  "error_code": "00001",
  "error_description": "step_up_token is required"
}
```

### Unauthorized

Returned when `step_up_token` is invalid, expired, or belongs to a different user.

```json
{
  "response_code": "00008",
  "message": "unauthorized",
  "error": "invalid_token",
  "error_code": "00008",
  "error_description": "unauthorized"
}
```

## Security Notes

- This endpoint must not be callable with only an email address.
- The returned `secret` and `otpauth_uri` are sensitive setup credentials.
- Clients should avoid logging the response body.
