# OpenGenesisLINK Viewer (OGL Viewer)

> **Status: M1 source import under review.** This branch includes the pinned
> Firestorm 7.2.4 C++ source and both Git histories. The import has not yet
> been merged into `main`, and no runnable OGL Viewer binary is verified.

[![Foundation checks](https://github.com/opengenesislink/opengenesislinkviewer/actions/workflows/foundation.yml/badge.svg)](https://github.com/opengenesislink/opengenesislinkviewer/actions/workflows/foundation.yml)

The **OpenGenesisLINK Viewer** is a planned, independent C++ viewer for
[OpenGenesisLINK](https://opengenesislink.de/) and compatible OpenSimulator grids.
Its long-term goal is a modern user experience, a higher-performance rendering
pipeline, and optional OGL-specific features, without abandoning the existing
OpenSimulator protocol and Hypergrid interoperability.

## Baseline

- Upstream: [Firestorm Viewer](https://github.com/FirestormViewer/phoenix-firestorm)
- Proposed reviewed release baseline: `Firestorm_7.2.4`
  ([upstream source](https://github.com/FirestormViewer/phoenix-firestorm/tree/Firestorm_7.2.4))
- Exact pinned commit: `10bd3c9f930c76e1427ddd4ecece6cdf36b4406d`
- Upstream main/nightly and preview branches are **not** the project baseline.
- Planned initial platform targets: Windows x64 and Linux x64.
- Initial upstream build configuration: `ReleaseOS` (OpenSimulator support).

## Delivery stages

| Target | Milestone | Definition |
| --- | --- | --- |
| M0 | Foundation | Project files, decisions, import plan, issue backlog |
| M1 | Buildable fork | Imported licensed source, reproducible OpenSim builds, clean startup/login |
| M2 | OGL Identity | Distinct name, icons, app IDs, data directories, installation and updater |
| M3 | OGL Services | Capability negotiation, search, optional wallet and marketplace clients |
| M4 | Modern UX | Accessible redesigned UI, configurable docks, inventory and quick actions |
| M5 | Renderer R&D | Profiling, render-interface seam, enhanced OpenGL path, Vulkan prototype |
| M6 | World Extensions | HydroEngine visualization, terrain streaming and region handoff research |
| M7 | Preview/Stable | Security, QA matrix, signed installers and staged releases |

See [ROADMAP.md](ROADMAP.md) for sequencing, gates and definitions of done.

## Repository map

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — architecture and responsibilities
- [docs/BUILD.md](docs/BUILD.md) — prerequisites and upstream OpenSim build
- [docs/UPSTREAM.md](docs/UPSTREAM.md) — upstream policy and source import
- [docs/PROTOCOL.md](docs/PROTOCOL.md) — optional OGL capability extensions
- [docs/RENDERER.md](docs/RENDERER.md) — renderer evolution and decision gates
- [docs/COMPATIBILITY.md](docs/COMPATIBILITY.md) — interoperability matrix
- [docs/QA.md](docs/QA.md) — testing, metrics and releases
- [docs/LEGAL.md](docs/LEGAL.md) — licensing and attribution checklist
- [docs/PROJECT_STATUS.md](docs/PROJECT_STATUS.md) — current verified state
- [docs/BACKLOG.md](docs/BACKLOG.md) — 25 tracked implementation issues
- [config/ogl-features.schema.json](config/ogl-features.schema.json) — **proposed**, not implemented protocol contract
- [scripts/import_firestorm.sh](scripts/import_firestorm.sh) — local guarded import helper
- [GitHub Issues](https://github.com/opengenesislink/opengenesislinkviewer/issues) — work breakdown

## Next operator action: source import

An existing empty/scaffold repository is not automatically a GitHub **fork**.
The helper prepares a history-preserving *source-import branch* locally. It
does not execute a remote push on its own.

```bash
git clone https://github.com/opengenesislink/opengenesislinkviewer.git
cd opengenesislinkviewer
bash scripts/import_firestorm.sh
# Review changes, run checks, then push and open a pull request:
git push -u origin feature/firestorm-source-import
```

Do not replace the GitHub repository with a `git push --force`; preserve the
foundation history and review the import as a separate change.

## License and attribution

The root [LICENSE](LICENSE) contains the verbatim **GNU LGPL 2.1** license
from the pinned upstream release. Existing copyright notices, attributions,
third-party licensing and redistribution conditions must be maintained after
import. The license status of independently authored planning files and new
components must be reviewed by maintainers. Do not strip Firestorm/Second Life notices from
derived source; branded assets are a separate trademark concern.

This project is independent of, and is not endorsed by, Firestorm or Linden Lab.
See [docs/LEGAL.md](docs/LEGAL.md).

## Contributing

Start with [CONTRIBUTING.md](CONTRIBUTING.md). Architecture decisions belong in
`docs/decisions/`; functionality requiring simulator changes must have a
documented viewer-side fallback.
