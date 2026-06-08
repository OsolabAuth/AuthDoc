# AI Agent Token Inspector

## Purpose

Make AI Agent delegated authentication visible in AuthPortal.

The existing AI Agent page can create agents and request tokens, but reviewers cannot easily inspect how the token represents the acting agent and the owner user. The Token Inspector decodes the JWT payload in the browser and shows the relevant claims for demonstration and troubleshooting.

## Target Page

- AuthPortal `/agent`

## User Goals

- Request an AI Agent token.
- Inspect the ID token payload.
- Inspect the access token payload.
- Confirm delegated-auth claims:
  - `principal_type`
  - `sub`
  - `agent_id`
  - `agent_name`
  - `owner_sub`
  - `delegation_id`
  - `scope`
  - `exp`

## UI Behavior

After `POST /agent/token` succeeds, AuthPortal:

1. Stores the raw token response JSON.
2. Extracts `id_token` and `access_token`.
3. Decodes JWT payloads locally.
4. Displays a compact claim table for each token.
5. Displays the raw decoded payload JSON for detailed review.

If a token is missing or malformed, the inspector shows a decode error and keeps the page usable.

## Security Notes

- The inspector is a display helper only.
- It does not verify JWT signatures.
- The UI must not say the token is trusted or verified.
- Raw tokens and secrets should remain in form fields or debug output only when the user explicitly requests them by using this development tool.

## API Compatibility Updates

AuthPortal must track the latest AuthFoundation security APIs:

- `/mfa/authenticator/setup` sends `step_up_token`.
- `/password/reset` sends `email_code`.

These fields are required because authenticator setup and password reset are high-risk operations.

## Acceptance Criteria

- Agent token response renders an ID token claim table when `id_token` exists.
- Agent token response renders an access token claim table when `access_token` exists.
- Invalid JWT strings produce a visible decode error without throwing.
- Authenticator setup form includes `step_up_token` and submits it.
- Password reset form includes `email_code` and submits it.
- `npm run test`, `npm run typecheck`, and `npm run build` succeed.
