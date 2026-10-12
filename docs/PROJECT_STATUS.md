# Verified project status

Last foundation update: 2026-10-12.

| Component | Status |
| --- | --- |
| GitHub repository | Created and initially empty; now initialized with foundation files |
| Roadmap / specifications | Authored as **proposals** |
| Firestorm upstream release baseline | Identified: `Firestorm_7.2.4`, commit `10bd3c9f930c76e1427ddd4ecece6cdf36b4406d` |
| Root LGPL-2.1 license text | Copied verbatim from pinned Firestorm release; dependency audit outstanding |
| Upstream viewer C++ source | **Imported in draft PR #26 only**; not yet merged into `main`; Linux Mint native C++ build verified |
| Actual OGL executable | **Built and launched on Linux Mint 22.3**; staged ELF and shared-library checks passed, GUI/OpenSimulator login reached `STATE_STARTED` on Stadt NexVerse; test log local to developer machine. Not a release-qualified build or installer |
| OGL proprietary API endpoints | **Not implemented** |
| Renderer/HydroEngine integration | **Not implemented** |
| CI | Upstream workflows disabled; Foundation/static ReleaseOS checks pass. Local Mint ReleaseOS compile and GUI/login smoke passed; Ubuntu 22.04 self-hosted native workflow not run, Windows native CI pending |
| M1 runtime and security | Avatar login / region entry **passed** (user confirmation and isolated Firestorm.log state `STATE_STARTED` on 2026-10-12). Inventory startup sequence traversed, but inventory interaction, teleport, LSL and voice are not verified. Native viewer currently inherits the Firestorm-specific Linux profile identity; separate launch via `FIRESTORM_X64_USER_DIR` has been verified. The NexVerse login endpoint is HTTP-only in the observed test; HTTPS/TLS remains an explicit security gate |\n| Production release | None |

Update this file only when verification evidence (commit, test log, artifact) exists. Do not mark milestones complete on the basis of a plan alone.
