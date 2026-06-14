# Runtime State Policy

## Policy

AuthFoundation must not keep cross-request state only in the Cloud Run instance memory.

In-memory values are allowed only when they are local variables or immutable service dependencies used within a single API request. Any state that must be read by a later request, another endpoint, or another application instance must be stored in an external state store.

## External State Stores

Use the following stores for runtime state.

| State | Store |
| --- | --- |
| Authorization request | Redis |
| Authorization code | Redis |
| Access token | Redis |
| Signup email challenge | Redis |
| MFA email challenge | Redis |
| Password reset email challenge | Redis |
| Step-up authorization grant | Redis |
| Attempt limiter counter | Redis |
| User profile | Auth DB |
| Password hash | Auth DB |
| Terms consent | Auth DB |

## Cloud Run Requirement

Cloud Run can route consecutive requests to different instances. Therefore, the following implementation is not acceptable in production.

```text
POST /password/reset/start
  Instance A stores email_code in a class field.

POST /password/reset
  Instance B receives the code but cannot read Instance A memory.
```

Production runtime must fail fast when Redis or Auth DB is not configured.

## Development Exception

In-memory stores may remain only for local development and unit tests. They must not be used as the production behavior.

The code should keep in-memory state behind explicit development fallback classes, such as `InMemoryOidcStore`, and production startup validation must prevent accidental use on Cloud Run.
