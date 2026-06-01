# AuthPortal Unit Test Harness

## Purpose

AuthPortal needs lightweight tests that can run without a browser, Nuxt dev server, or AuthFoundation backend.

The first production-hardening tests read Vue source files and verify that unsafe development behavior is not present. That is useful for guardrails, but it does not test reusable client logic directly. New client logic should be extracted into small utility modules and covered with `node --test`.

## Target

- AuthPortal
- `utils/*`
- Source guard tests under `tests/*`

## Policy

For each new client feature:

1. Keep page-level code focused on state, API calls, and rendering.
2. Move reusable parsing, formatting, token inspection, validation, or request-shaping logic into `utils`.
3. Add direct unit tests for utility behavior with `node --test`.
4. Keep source guard tests for UX/security requirements that are easiest to verify from the page source.
5. Run `npm.cmd run test`, `npm.cmd run typecheck`, and `npm.cmd run build` before opening or updating the PR.

## Initial Scope

The AI Agent Token Inspector decodes JWT payloads in the browser.

Move the following logic from `pages/agent.vue` into a utility:

- JWT shape detection
- Base64url payload decode
- JSON payload parse
- delegated-auth claim formatting
- empty/malformed token handling

## Acceptance Criteria

- `pages/agent.vue` imports token inspection logic from `utils`.
- Utility tests cover:
  - empty token
  - malformed non-JWT token
  - valid JWT payload
  - array claim formatting
  - invalid base64url or invalid JSON payload
- Existing production hardening source tests continue to pass.
* `npm.cmd run test` passes.
* `npm.cmd run typecheck` passes.
* `npm.cmd run build` passes.
