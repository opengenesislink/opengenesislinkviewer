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
| OGL JSON discovery v1 integration | Server has the v1 discovery implementation/specification in `opengenesislinkserver` (`doc/NexVerse/OGL_VIEWER_DISCOVERY.md`, server commit `3f8669847a8e`). Public endpoint still returned HTTP 404 when checked on 2026-10-12, whereas legacy XML/JSON GridInfo returned HTTP 200. Viewer now has a first asynchronous v1 JSON status probe and color-coded legacy/OGL login badge in all six English classic/new XUI layouts; the Firestorm login is unchanged. **Linux Mint native C++ incremental rebuild passed (Exit 0); staged ELF/library smoke passed; actual X11 login GUI confirmed the OpenSim Legacy badge visible for NexVerse while the live OGL JSON endpoint was HTTP 404 on 2026-10-12.** HTTPS-positive/OGL-verifiziert and HTTP-positive/OGL-erkannt cases have not yet been exercised against a live OGL JSON server. Integration/security behavior documented in `docs/OGL_SERVER_DISCOVERY.md` |
| Renderer/HydroEngine integration | **Not implemented** |
| CI | Upstream workflows disabled; Foundation/static ReleaseOS checks pass. Local Mint ReleaseOS compile and GUI/login smoke passed; Ubuntu 22.04 self-hosted native workflow not run, Windows native CI pending |
| M1 runtime and security | Avatar login / region entry **passed** (user confirmation and isolated Firestorm.log state `STATE_STARTED` on 2026-10-12). User-reported interactive checks passed on 2026-10-12 for avatar rendering, inventory usage, teleport, chat and LSL; these are functional acceptance reports, not automated regression evidence. Voice is **not testable yet** because the OpenGenesisLINK server does not currently provide voice support; this is a server-side test dependency, **not a demonstrated viewer bug**. M2 source now selects an independent `OpenGenesisLINK_x64` app-data identity (and `OPENGENESISLINK_X64_USER_DIR` for isolated test runs); the changed binary/profile initialization is pending validation. The NexVerse login endpoint is HTTP-only in the observed test; HTTPS/TLS remains an explicit security gate |
| M2 edge UI | Native collapsible left/right inworld edge drawers implemented. User-persisted settings, existing inventory/avatar/people/chat and map/minimap/build/preferences floater actions, and window-resize anchoring. Initial incremental C++ build passed; authenticated inworld mouse and visual acceptance **pending** |\n| Production release | None |


## M1 OpenSimulator functional test matrix (2026-10-12)

These results were explicitly confirmed by the developer while testing the
native Linux Mint `ReleaseOS` viewer on Stadt NexVerse. Interactive checks
are **user-reported** unless a log-based verification is separately noted.

| Test | Result | Basis |
| --- | --- | --- |
| Native Linux C++ build | PASS | Local build log, exit 0 |
| Staged ELF and shared libraries | PASS | Local binary smoke check, exit 0 |
| Viewer GUI initialization | PASS | Window observed; isolated startup log |
| OpenSimulator login / region entry | PASS | `STATE_STARTED` in isolated startup log and developer confirmation |
| Avatar rendering | PASS (user-reported) | Inworld visual test |
| Inventory interaction | PASS (user-reported) | Inworld functional test; not merely inventory initialization |
| Region teleport | PASS (user-reported) | Inworld functional test |
| Chat | PASS (user-reported) | Inworld functional test |
| LSL | PASS (user-reported) | Inworld script functional test |
| Voice | BLOCKED: SERVER DEPENDENCY | No voice backend available on the OpenGenesisLINK server; viewer side not validated |
| Ubuntu 22.04 reference build | PENDING | Native CI runner/reference build required |
| Windows x64 build | PENDING | Native compilation and smoke test required |
| Distinct product identity and user-data paths | IN PROGRESS | Source-controlled default app-data identity now uses OpenGenesisLINK_x64, isolated launcher updated. Native build/profile path smoke pending; product executable, installer, desktop integration and icons not yet renamed |
| TLS-protected grid login | PENDING: SECURITY GATE | Observed login URI is HTTP; HTTPS port 443 unavailable during earlier probe |
| License / third-party notice audit | PENDING | Audit before release and PR merge |

For M1, voice is classified as **deferred and untested**, not failed. Do not
claim voice compatibility or count a nonexistent server voice service as a
client regression. Reopen end-to-end voice validation as soon as the server
component supports it; any release without voice must disclose the missing
feature. The remaining build, security, licensing and identity gates stay
open; PR #26 must remain draft until its merge criteria are met.

Update this file only when verification evidence (commit, test log, artifact) exists. Do not mark milestones complete on the basis of a plan alone.
