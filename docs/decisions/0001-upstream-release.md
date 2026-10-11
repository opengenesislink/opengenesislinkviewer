# ADR-0001: Pin a stable Firestorm release

Status: **Proposed** — 2026-10-12.

Decision: begin the engineering fork from official
`Firestorm_7.2.4` at `10bd3c9f930c76e1427ddd4ecece6cdf36b4406d`,
not from nightly master or the `7.2.5_preview` branch.

Rationale: stable upstream point-in-time and traceable maintenance. This
baseline is to be revalidated for security and buildability before acceptance.

Consequence: upstream fixes require reviewed cherry-picks or tracked merges.
Architecture must not depend on future master-only APIs.
