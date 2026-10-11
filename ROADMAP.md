# OGL Viewer Roadmap

**Planning baseline:** 2026-10-12. **Status:** targets, not delivery promises. All phases start as **Not started** unless a verified artifact explicitly states otherwise.

## Principles and non-negotiable gates

1. Maintain standard OpenSimulator/Hypergrid operation without OGL-only services.
2. Secure, recoverable viewer installs: OGL must not overwrite Firestorm's profile, cache, logs or app IDs.
3. Feature negotiation before any OGL-specific request; no privileged authority in client code.
4. Upstream license, notices, provenance and third-party licenses remain intact.
5. Evidence-based performance decisions with reproducible benchmarks.
6. No claim of "seamless", "raytraced", "AI", or "production ready" before defined acceptance tests pass.

## Milestone M0 — Foundation (priority P0, partially done)

**Outcome:** An auditable plan and a collaboration-ready repository.

- [x] Create repository foundation, architecture, roadmap and governance docs.
- [x] Pin a proposed stable Firestorm release branch and commit.
- [x] Define capability/API draft, feature flags and fallback policy.
- [x] Add source import and development/build helper scripts.
- [x] Define GitHub backlog and lightweight foundation validation.
- [ ] Perform a full third-party-license and assets audit with imported source.
- [ ] Approve external branding, distribution and release policies.

**Exit gate:** All foundation checks pass; maintainers approve import method and legal review plan.

## Milestone M1 — Buildable OpenSim fork (P0)

**Outcome:** Original Firestorm source under reviewed OGL branch, reproducibly compiled.

- [ ] Import Firestorm `Firestorm_7.2.4` at `10bd3c9f930c76e1427ddd4ecece6cdf36b4406d`.
- [ ] Preserve upstream history/attribution and record upstream remote.
- [ ] Verify `ReleaseOS` on Linux x64 and Windows x64; publish exact toolchain logs.
- [ ] Document runtime dependencies and build artifact provenance.
- [ ] Login / teleport / inventory / attachments / LSL / voice baseline smoke tests.
- [ ] Configure CI runners; do not label documentation-only checks as viewer builds.

**Exit gate:** Clean clone can produce launchable OpenSim-enabled builds on each claimed platform; at least one OGL grid login verified with test account.

## Milestone M2 — Branding and coexistence (P0)

- [ ] Dedicated channel, app title, bundle IDs, launcher, icon and splash.
- [ ] Isolated cache, settings, credentials and crash logs.
- [ ] Explicit default grid and user-controlled grid manager.
- [ ] OGL updater and signed release-channel metadata; rollback strategy.
- [ ] Original vendor notices and third-party acknowledgements accessible in UI.

**Exit gate:** OGL and Firestorm installed side-by-side with no data collisions; upgrade/rollback test passes.

## Milestone M3 — Platform services (P1)

- [ ] Detect OGL capabilities on region entry, never trust arbitrary host redirects.
- [ ] Client protocol module with version negotiation, auth, timeouts and opt-in flags.
- [ ] Search integration with graceful web/legacy fallback.
- [ ] NV$ read-only wallet display, followed by authenticated transaction flows.
- [ ] Marketplace deep links, then purchases only with server-authoritative confirmation.
- [ ] Telemetry with explicit consent, minimal data and documented retention.

**Exit gate:** Standard OpenSim grids remain usable with all OGL feature endpoints absent.

## Milestone M4 — Modern UX (P1)

- [ ] Navigation / docking / responsive scaling / keyboard accessibility.
- [ ] Inventory search and appearance flow without loss of inventory semantics.
- [ ] Creator workspace: inspector, prim/mesh tools and script editor improvements.
- [ ] User testing for first-run, avatar changes, building and payments.

**Exit gate:** Core flows measured against M1 with no functional regressions.

## Milestone M5 — Rendering and performance (P1 research; later P2 product)

- [ ] Fixed test scene and benchmark harness: CPU frame time, GPU frame time, frame pacing, VRAM, texture stalls.
- [ ] Refactor render-resource boundaries with OpenGL as the functional baseline.
- [ ] Improve culling, upload scheduling, texture streaming and profiling.
- [ ] Vulkan feasibility prototype behind a disabled-by-default flag.
- [ ] Evaluate lighting, compute effects and hardware RT only after parity tests.

**Exit gate:** A/B data on at least three GPU tiers; stable fallback, no regression in avatar/alpha/PBR/terrain/UI.

## Milestone M6 — World extensions (P2 research)

- [ ] HydroEngine service contract and client visualization of authoritative water state.
- [ ] Streaming terrain and optional variable-region / LOD research.
- [ ] Prefetch and simulation-aware region crossing; no guarantee of zero interruption.
- [ ] Federation directory, voice interoperability and secure identity research.

**Exit gate:** Opt-in experiments do not corrupt world state and retain non-OGL fallbacks.

## Milestone M7 — Preview and stable release (P0 for release)

- [ ] CI on supported platforms; smoke / regression / rendering matrix.
- [ ] Signed, reproducible releases; update channel, SBOM and vulnerability scanning.
- [ ] Third-party notices and user privacy documentation.
- [ ] Incident response, release notes, crash triage and rollback drills.

**Exit gate:** All blocker issues resolved; release sign-off recorded.

## Dependency sequence

`M0 -> M1 -> M2 -> M3/M4 -> M5 -> M6 -> M7`. Security, QA and licensing run continuously. Renderer R&D can start in parallel with M3 after M1 baseline metrics exist.

## Priority model

- **P0:** security, legality, reproducible build, interoperability, data integrity.
- **P1:** user value and maintainable integration.
- **P2:** advanced research with high uncertainty.

## Release versioning (proposal)

`0.1.0-dev` = first buildable developer preview, `0.2.x` = branding/core services, `0.3.x` = modern UX, `0.4.x` = renderer experiments. No version number implies a delivery date. `1.0.0` only after M7 stable gates.
