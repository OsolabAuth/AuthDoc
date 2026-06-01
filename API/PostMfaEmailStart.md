# POST /mfa/email/start

Starts an email MFA challenge.

## Request

```json
{
  "email": "user@example.com"
}
```

## Response

The verification code itself must not be returned.

```json
{
  "result": "challenge_created",
  "delivery": "email",
  "email": "user@example.com",
  "expires_at": "2026-06-01T12:00:00Z"
}
```

## Error

| HTTP status | response_code | error | condition |
| --- | --- | --- | --- |
| 400 | `00001` | `invalid_request` | `email` is invalid |
| 401 | `00008` | `invalid_token` | user does not exist |

## Security Requirements

- Do not include `code` in the response.
- Generate MFA codes with a cryptographically secure random number generator.
- Keep the code short-lived.
- Make the code one-time use after successful verification.
