# Password Reset Flow

```text
User -> AuthPortal
  Enter login email and birth date.

AuthPortal -> AuthFoundation
  POST /password/reset/start

AuthFoundation -> AuthFoundation
  Validate email and birth_date format.

AuthFoundation -> User Store
  Find user by login email.

AuthFoundation -> Email Sender
  Send email_code only when the user exists and birth_date matches.

AuthFoundation -> AuthPortal
  200 reset_challenge_started.
  The response does not reveal whether the account or birth date matched.

User -> AuthPortal
  Enter email_code and new password.

AuthPortal -> AuthFoundation
  POST /password/reset

AuthFoundation -> AuthFoundation
  Validate email_code and new password policy.
  Verify the email_code.

AuthFoundation -> User Store
  Verify birth_date and update password hash.

AuthFoundation -> AuthPortal
  200 password_reset
```
