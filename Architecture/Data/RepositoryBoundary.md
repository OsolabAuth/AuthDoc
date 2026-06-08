# Repository Boundary for InMemory Stores

## Purpose

Separate AuthFoundation application code from the concrete in-memory stores.

The current implementation keeps users, OIDC sessions, access tokens, and AI agent delegations in in-memory classes. That is acceptable for a minimal port, but controllers and token services depend directly on those concrete classes. This makes the next persistent implementation harder to review because storage changes and endpoint behavior changes would be mixed in the same pull request.

## Target

- `InMemoryUserStore`
- `InMemoryOidcStore`
- `InMemoryAgentStore`
- Controllers that currently depend on those concrete stores
- Services that currently depend on those concrete stores

## New Interfaces

Add the following interfaces in the service layer:

- `IUserStore`
- `IOidcStore`
- `IAgentStore`

The in-memory classes remain the default implementation and continue to own the current behavior.

## Dependency Direction

Controllers and domain services must depend on the interfaces.

```text
Controller / Service
  -> IUserStore / IOidcStore / IAgentStore
    -> InMemoryUserStore / InMemoryOidcStore / InMemoryAgentStore
```

## Non-goals

This change does not add SQL persistence.

This change does not alter token lifetime, authorization request behavior, password behavior, AI agent scopes, or response payloads.

## Acceptance Criteria

- AuthFoundation registers each interface in dependency injection.
- Controllers no longer depend directly on `InMemoryUserStore`, `InMemoryOidcStore`, or `InMemoryAgentStore`.
- `StepUpService` and `OidcTokenService` depend on the store interfaces.
- Existing endpoint tests pass without behavior changes.
- Coverage remains at the current required level because the change is a refactor of dependency boundaries, not new behavior.
