# Architecture — OGL Viewer

## System context

```text
+--------------------------- OGL Viewer (C++) ---------------------------+
| OGL UX / Accessibility / Inventory / Creator / Search / Economy UI     |
| Core avatar + world simulation client | Optional OGL Feature Manager  |
| Asset Cache / Prefetch / Render Scene | Audio / Voice | Diagnostics    |
| Render backend adapter -> OpenGL baseline -> optional Vulkan R&D      |
+---------------------------+-------------------------------------------+
                            | LLUDP / HTTPS CAPS / inventory / assets
                            v
+-------------------- OpenGenesisLINK / OpenSimulator (C#) -------------+
| Region / ROBUST / Asset / Economy / Permissions / LSL / Physics       |
| Optional OGL Capabilities: Search, Wallet, Hydro, Federation, Terrain |
+---------------------------+-------------------------------------------+
                            | authenticated integration; external APIs
                            v
             OGL search / marketplace / user-controlled services
```

## Trust boundaries

The viewer is an untrusted client. Server owns all balances, transfers,
permissions, land rights, inventory authorization, Hydro simulation state and
federation identity. Viewer presents state; no client-originated "balance"
or debit-permission grant is authoritative.

HTTPS capabilities must be received through trusted login/region negotiation,
must be scoped to the current session/region, must be short-lived when possible,
and must not expose tokens in logs or arbitrary redirects. Strict size/time limits.

## Suggested source decomposition after import (conceptual, not existing paths)

- `indra/newview/ogl/`: viewer-facing feature coordination and adapters.
- `indra/newview/ogl/services/`: typed HTTPS clients, auth/capability manager.
- `indra/newview/ogl/ui/`: UX view models and Floater integrations.
- `indra/newview/ogl/renderer/`: eventual rendering seam and profiling.
- `indra/newview/ogl/world/`: terrain, Hydro and crossing visual adapters.
- `indra/newview/ogl/diagnostics/`: feature negotiation and opt-in logs.

Do not create parallel copies of core inventory, avatar or permissions systems.
Use existing Firestorm codepaths through small adapters. Exact directories must
be confirmed with the source imported and a compileable dependency graph.

## Module contracts

Each OGL module should expose: feature ID, protocol min/max version, dependencies,
user opt-in/default, init/shutdown, network timeout, diagnostics category, fallback.
Prefer C++ RAII, ownership clarity and existing viewer threading conventions.
Avoid blocking rendering or the main UI thread on network calls.

## Service flow

1. Standard OpenSimulator login -> region seed capability.
2. Viewer discovers advertised optional OGL capability.
3. Validate advertised transport and protocol version.
4. Apply local opt-in/policy then request server feature manifest.
5. Enable only compatible services; otherwise standard viewer behavior.
6. On region change/log out: cancel requests, expire tokens, clear scoped state.

## Configuration principles

Never hardcode account/operator UUIDs, bank credentials, production API secrets
or administrative capability URLs. Use developer/test configuration and dynamic
discovery. Respect accessible settings migration and secret storage.

## Dependencies

See [PROTOCOL.md](PROTOCOL.md), [RENDERER.md](RENDERER.md),
[COMPATIBILITY.md](COMPATIBILITY.md), [LEGAL.md](LEGAL.md).
