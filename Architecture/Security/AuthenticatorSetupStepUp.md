# Authenticator Setup Step-up Requirement

## Purpose

Protect authenticator app registration from account takeover.

`POST /mfa/authenticator/setup` issues a new TOTP secret. If this endpoint only accepts an email address, an attacker who can call the API can overwrite or create an authenticator setup for another user. The setup operation is a high-risk account security change and must require a recent step-up authorization.

## Target

- `POST /mfa/authenticator/setup`

## Previous Behavior

The request body only contained `email`.

```json
{
  "email": "user@example.com"
}
```

This allowed authenticator setup without proving recent possession of another factor.

## New Behavior

The request body must include a valid `step_up_token`.

```json
{
  "email": "user@example.com",
  "step_up_token": "sup_xxx"
}
```

AuthFoundation validates:

- `email` is present and valid.
- `step_up_token` is present.
- `step_up_token` exists and is not expired.
- The step-up grant subject matches the requested user.

The endpoint returns `401 invalid_token` when the step-up token is missing, invalid, expired, or belongs to another user.

## Step-up Source

For initial authenticator setup, the user can use email MFA:

1. `POST /mfa/email/start`
2. User receives the email verification code.
3. `POST /mfa/email/verify`
4. Use the returned `step_up_token` for `POST /mfa/authenticator/setup`.

For authenticator rotation, either email MFA or an existing authenticator step-up token can be used.

## Response

Successful setup returns the authenticator provisioning data.

```json
{
  "email": "user@example.com",
  "secret": "BASE32SECRET",
  "otpauth_uri": "otpauth://totp/OsolabAuth:user@example.com?secret=BASE32SECRET&issuer=OsolabAuth&algorithm=SHA1&digits=6&period=30"
}
```

`secret` and `otpauth_uri` are sensitive. Clients should display them only during setup and avoid storing them in logs.

## Acceptance Criteria

- Authenticator setup without `step_up_token` is rejected.
- Authenticator setup with a token for a different user is rejected.
- Authenticator setup with a valid token for the requested user succeeds.
- API Tester scenarios chain `step_up_token` from email verification into authenticator setup.
- Unit tests cover success, missing token, invalid email, and subject mismatch.
