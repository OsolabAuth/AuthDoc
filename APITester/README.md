# APITester scenarios

This folder contains Talend API Tester import JSON files for AuthFoundation.

Each file name should match the related `Sequence/*.md` file name when a sequence exists. When a feature changes a sequence, update the matching APITester JSON in the same feature commit.

## Environment

The default environment is `production` and points at:

| Name | Default | Notes |
| --- | --- | --- |
| `AuthServer` | `https://auth.osolab-auth.jp` | AuthFoundation production base URL |
| `ClientId` | `30000000000000000000000000000001` | Taiga production OIDC client by default |
| `RedirectUri` | `https://taiga.osolab.jp/oidc/callback/` | Must exactly match the registered redirect URI |
| `Scope` | `openid email profile` | Requested OIDC scope |
| `CodeVerifier` / `CodeChallenge` | replace before run | Generate a valid S256 PKCE pair before running auth scenarios |
| `Email` / `Password` | replace before run | Use only a dedicated production test account |

Do not run destructive scenarios such as `Withdrawal.json` against a real user account.

## Scenario value references

Scenarios should pass values from previous responses directly. Prefer request-name references over manual copy/paste variables.

Talend API Tester export structure should keep requests under the scenario:

```text
Project
  Scenario
    Request
    Request
```

Example:

`${"AuthFoundation - AuthorizationCodeFlow"."01. Start authorize request"."response"."body"."response_code"}`

Common references used by these scenarios:

| Value | Reference pattern |
| --- | --- |
| Authorization code | `${"AuthFoundation - AuthorizationCodeFlow"."02. Login for authorize session"."response"."body"."authorization_code"}` |
| Access token | `${"AuthFoundation - AuthorizationCodeFlow"."03. Exchange authorization code"."response"."body"."access_token"}` |
| MFA email code | `${"EmailCode"}` |
| Step-up token | `${"AuthFoundation - MfaStepUp"."02. Verify email MFA"."response"."body"."step_up_token"}` |

Do not add a manual `Cookie` header to the login request. The authorize response sets `AuthRequestSessionId`; Talend API Tester should let Chrome carry that cookie to `/login`.

Email MFA codes are never read from `/mfa/email/start` responses. Enter the code received by mail manually into the private `EmailCode` environment variable for verification requests.

