# GET /agent/me

## Purpose

Validate an AI agent credential and return the active delegated identity metadata without issuing a token.

This endpoint is intended for CLI tools, MCP clients, and agent workers that need a lightweight connectivity check before requesting a bearer token.

## Request

```http
GET /agent/me?client_id=30000000000000000000000000000001&scope=task_read
Authorization: Basic base64(agent_id:agent_secret)
```

## Query Parameters

| Name | Required | Description |
| --- | --- | --- |
| `client_id` | yes | OIDC client that receives the delegated agent token. |
| `scope` | yes | Requested delegated scopes. Must be a subset of the delegation. |

## Authentication

Use HTTP Basic authentication.

```text
username = agent_id
password = agent_secret
```

Do not send `agent_secret` in the URL query string.

## Success Response

```json
{
  "principal_type": "ai_agent",
  "agent_id": "agent_abc123",
  "agent_name": "Issue Triage Agent",
  "owner_sub": "user_123",
  "delegation_id": "del_abc123",
  "client_id": "30000000000000000000000000000001",
  "scope": "task_read",
  "expires_at": "2026-06-30T00:00:00+00:00",
  "status": "active"
}
```

## Error Handling

- Missing or malformed `Authorization` header returns `401 invalid_token`.
- Unknown agent, wrong secret, revoked agent, expired delegation, or unknown client returns `401 invalid_token`.
- Unsupported or undelegated scope returns `400 invalid_scope`.
- Missing or malformed `client_id` or `scope` returns `400 invalid_request`.

## Acceptance Criteria

- Endpoint reuses the same grant verification path as `POST /agent/token`.
- `agent_secret` is never returned.
- Successful response contains the principal, owner, delegation, client, scope, expiry, and status.
- Unit tests cover success, missing Basic auth, wrong secret, and undelegated scope.
