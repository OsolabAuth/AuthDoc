# Password Reset Email Code Requirement

## Purpose

Protect password reset from knowledge-only verification.

The password reset endpoint already requires the login email address and birth date. Birth date is personal information, but it is often guessable or leaked elsewhere. Password reset must also prove possession of the login email address by requiring an email verification code.

## Target

- `POST /password/reset`

## Previous Behavior

The request body contained `email`, `birth_date`, and `new_password`.

```json
{
  "email": "user@example.com",
  "birth_date": "2000-01-02",
  "new_password": "Newpass1!"
}
```

This allowed password reset with knowledge of the email address and birth date only.

## New Behavior

The request body must include `email_code`.

```json
{
  "email": "user@example.com",
  "birth_date": "2000-01-02",
  "email_code": "123456",
  "new_password": "Newpass1!"
}
```

AuthFoundation validates:

- `email` is present and valid.
- `email_code` is present.
- `email_code` verifies an active email MFA challenge for the same login email address.
- Reset attempts are within the configured rate limit for the login email address, IP address, and email challenge.
- `birth_date` is present, formatted as `yyyy-MM-dd`, and matches the registered value.
- `new_password` satisfies the password policy.

The email verification code is checked and consumed before comparing `birth_date`. This keeps password reset from becoming a birth-date oracle for anyone who does not possess the login email address.

## Flow

1. User starts an email MFA challenge with `POST /mfa/email/start`.
2. AuthFoundation sends the code to the login email address.
3. User submits `POST /password/reset` with email, birth date, email code, and new password.
4. AuthFoundation verifies and consumes the email code.
5. AuthFoundation applies password reset attempt limits.
6. AuthFoundation verifies the birth date before updating the password.

## Error Handling

- Missing or malformed fields return `400 invalid_request`.
- Unknown user, birth date mismatch, expired email code, or wrong email code return `401 invalid_token`.
- Repeated reset failures for the same email address, IP address, or challenge return `429 too_many_requests`.
- Password is not changed when validation fails.

## Acceptance Criteria

- Password reset without `email_code` is rejected.
- Password reset with wrong `email_code` is rejected.
- Password reset with mismatched `birth_date` is rejected.
- Password reset rate limits are checked before birth date mismatch details can be inferred.
- Password reset with matching `birth_date` and valid `email_code` succeeds.
- API Tester scenarios include `email_code` as a private environment variable.
- Unit tests cover success, missing code, wrong code, birth date mismatch, invalid birth date, and weak password.
