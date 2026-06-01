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
- `birth_date` is present, formatted as `yyyy-MM-dd`, and matches the registered value.
- `email_code` is present.
- `email_code` verifies an active email MFA challenge for the same login email address.
- `new_password` satisfies the password policy.

## Flow

1. User starts an email MFA challenge with `POST /mfa/email/start`.
2. AuthFoundation sends the code to the login email address.
3. User submits `POST /password/reset` with email, birth date, email code, and new password.
4. AuthFoundation verifies the birth date and email code before updating the password.

## Error Handling

- Missing or malformed fields return `400 invalid_request`.
- Unknown user, birth date mismatch, expired email code, or wrong email code return `401 invalid_token`.
- Password is not changed when validation fails.

## Acceptance Criteria

- Password reset without `email_code` is rejected.
- Password reset with wrong `email_code` is rejected.
- Password reset with mismatched `birth_date` is rejected.
- Password reset with matching `birth_date` and valid `email_code` succeeds.
- API Tester scenarios include `email_code` as a private environment variable.
- Unit tests cover success, missing code, wrong code, birth date mismatch, invalid birth date, and weak password.
