# OGL capability protocol — proposal v0 (NOT IMPLEMENTED)

This document names proposed extensions only. `OGLGetFeatures`,
`OGLWallet`, `OGLHydroState`, `OGLTerrainStream`, `OGLSearch`,
`OGLFederation` are **not** standard OpenSimulator capability names.

## Capability discovery

Use OpenSimulator's established login/seed-capability pattern. A region that
supports OGL may advertise the HTTPS endpoint `OGLGetFeatures`. If absent,
viewer must **not probe guessed URLs**. A grid-wide service could also be
advertised via a standard trusted grid-info channel after threat review.

`GET OGLGetFeatures` — proposed JSON response:

```json
{
  "protocol": "ogl.capabilities",
  "protocolVersion": "0.1",
  "gridId": "example-grid-id",
  "regionId": "00000000-0000-0000-0000-000000000001",
  "features": {
    "search": {"version": "0.1", "available": true},
    "wallet": {"version": "0.1", "available": false},
    "hydro": {"version": "0.1", "available": false},
    "terrainStream": {"version": "0.1", "available": false},
    "federation": {"version": "0.1", "available": false}
  }
}
```

This is a **design example**, not a response from a deployed service. The
machine-readable schema in `config/ogl-features.schema.json` validates the
response envelope, not authentication, transport or semantics.

## Security

- HTTPS only; TLS certificate validation never disabled.
- Feature manifest not a bearer token. Actual operation endpoints are
  separately scoped to the authenticated agent/session and permissions.
- No client-visible master-bank operator IDs or server signing keys.
- A wallet read is non-authoritative presentation; payment uses server-side
  validation, transaction ID, replay/idempotency protection, CSRF/session
  binding as applicable, clear consent and confirmations.
- Protect against SSRF-style redirects through allowlist/scoped CAP issuance.
- Explicit retries, bounded response sizes and circuit breakers.
- No leaking capability URLs (which can contain tokens) to console logs.

## Versioning

Client supports a set of major/minor protocol versions. Reject unknown major
versions; ignore unknown optional fields; reject invalid mandatory fields.
Feature flags must be negotiated **per region/session** and cleared on crossing.
Always fall back to standard OpenSimulator behavior.

## Required server work

Create separate OpenGenesisLINK C# region/ROBUST modules with end-to-end tests;
document ownership, session authentication, permission enforcement, audit logs,
resource limits and deploy/rollback. Viewer-side examples alone do nothing.

## Proposed endpoint phases

1. Read-only feature discovery and search deep-link.
2. Read-only wallet view; separately audited debit and payment actions.
3. Hydro snapshots or bounded deltas.
4. Terrain streaming, federation and handoff **after** threat modeling.

See [docs/ECONOMY.md](ECONOMY.md) and [docs/HYDROENGINE.md](HYDROENGINE.md).
