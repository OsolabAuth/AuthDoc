# MFA Email Code Hardening

## Goal

Do not include email MFA verification codes in API responses.

The email MFA code is an authentication factor that should be delivered through email. Returning it through the API can expose it through browser DevTools, proxy logs, application logs, screenshots, and API tester history.

## Findings

Target:

- `POST /mfa/email/start`
- `StepUpService.StartEmailChallenge`

Issues:

- `POST /mfa/email/start` includes `code` in the response.
- `delivery` is fixed to `development_response`.
- `StepUpService.StartEmailChallenge` uses `Random.Shared` to generate the code.

## Policy

### API Response

`POST /mfa/email/start` returns only the challenge start result.

```json
{
  "result": "challenge_created",
  "delivery": "email",
  "email": "user@example.com",
  "expires_at": "2026-06-01T12:00:00Z"
}
```

The response must not include:

- `code`
- the verification code itself
- values derived from the verification code

### Code Generation

The email MFA code is a 6-digit numeric code generated with a cryptographically secure random number generator.

```text
RandomNumberGenerator.GetInt32(0, 1_000_000)
```

### Development Verification

Development code inspection must not rely on the production API response.

If local development needs a code inspection path, design one of these separately:

- direct service access in unit tests
- development-only email logs
- a test mailbox

## Impact

- AuthFoundation
- API Tester MFA scenario
- AuthPortal MFA screen

AuthPortal already stopped displaying MFA codes, so this change does not require a portal UI update.

The API Tester email MFA scenario can no longer chain `code` from the start response into the verify request. End-to-end manual verification needs real email delivery or a test mailbox.

## Test Points

- `/mfa/email/start` response does not expose `code`.
- `/mfa/email/start` returns `delivery = email`.
- `/mfa/email/start` returns `expires_at`.
- `StepUpService.StartEmailChallenge` generates a 6-digit code.
- `StepUpService.StartEmailChallenge` uses a cryptographically secure random generator.
- `VerifyEmailChallenge` still issues a step-up token when given the correct code.
