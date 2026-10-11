# Test strategy and acceptance evidence

## Tiers

- T0 (foundation): validation of roadmap paths, JSON schemas/examples,
  shell syntax and non-secret content.
- T1 (source): compilation, unit tests, sanitizer builds where feasible.
- T2 (integration): actual OGL + stock OpenSimulator login, CAPS behavior,
  payments (test currency only), identity and authorization tests.
- T3 (runtime): live viewer smoke tests, animations, appearance, inventory,
  teleport, region boundaries, high-latency/reconnect and plugin failures.
- T4 (graphics): consistent scene captures, performance regressions, driver
  stability, texture budget and fallback.
- T5 (release): packaging, concurrent Firestorm install, updater, signed
  artifacts, rollback and complete attribution.

## Minimum test scenes

1. Empty region (cold startup).
2. Urban terrain with linked objects and PBR materials.
3. Crowded avatar event including rigged mesh / attachments.
4. Dense transparency/water and multiple alpha blend modes.
5. Two adjacent regions with variable latency and OGL feature mismatch.
6. Stock OpenSimulator grid with no OGL extensions enabled.

## Evidence expected for every PR

Linked issue, acceptance conditions, threat impact, affected protocols, user
feature flag, observable test steps, screenshots or profiler logs where
relevant, and fallback evidence.

## Definition of done

A feature is done only if implemented, reviewed, documented, tested against
its acceptance criteria and released behind an appropriate rollout gate.
