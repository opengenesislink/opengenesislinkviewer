# ADR-0002: Optional CAPS with stock OpenSimulator fallback

Status: **Proposed** — 2026-10-12.

Decision: add optional versioned OGL service capability discovery by trusted
simulator CAPS. Never require custom OGL endpoints for basic login, inventory,
region crossing or Hypergrid travel.

Trade-off: more explicit negotiation / tests in exchange for interoperability.
Server retains all authz and economy authority.
