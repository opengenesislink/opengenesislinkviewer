# Contributing

This is an engineering foundation, not yet a compilable viewer. Before
implementing an issue, link it to a roadmap milestone and check
`docs/PROJECT_STATUS.md`.

## Contribution checklist

1. Open/link an Issue with measurable acceptance criteria and fallback.
2. For behavior changes, document affected OpenSimulator protocols / auth.
3. For structural decisions, propose an ADR in `docs/decisions/`.
4. Commit on a topic branch; use descriptive messages
   (`feat:`, `fix:`, `docs:`, `chore:`).
5. Run foundation validation: `python3 scripts/check_scaffold.py`;
   after import, run actual viewer builds/tests.
6. Submit a PR including tests, risk assessment, license origin, screenshots
   and performance comparison if applicable.
7. Do not commit tokens, UUID secrets, private bank credentials or client
   identifiers granting server-level privileges.

Contribute upstream-compatible fixes to upstream when feasible. Always keep
source modification records and copyright notices intact.

## Coding principles after import

C++ changes should fit Firestorm conventions and be isolated in OGL adapters
where possible. Prefer opt-in, region-negotiated features with a stock-grid
fallback. Do not block rendering/UI on I/O. Performance improvements need
reproducible baselines and no accepted crash-rate regression.

## Branch flow

`main` = reviewed integration; `feature/*` = new capabilities;
`fix/*` = defects; `research/*` = experiments; `release/*` = stabilization.
Review first; do not push a complete upstream overwrite onto `main`.
