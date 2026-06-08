# POST /mfa/authenticator/verify

AuthenticatorアプリのTOTPコードを検証する。

## Response

検証成功時、短時間のstep-up状態を発行する。

## Security Requirements

- Failed TOTP verification attempts are rate limited.
- The attempt key includes at least login email address and request IP address.
- The initial limit is 5 failed attempts per 5 minutes.
- When the limit is exceeded, the API returns an authentication failure before comparing the submitted TOTP code.
- Successful verification resets or consumes the relevant failure counter according to the shared `AttemptLimiter` policy.
