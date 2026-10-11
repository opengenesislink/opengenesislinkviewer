# CI policy for OGL Viewer source import

The imported Firestorm source includes workflows designed for Firestorm and
Linden Lab infrastructure. These may try to run Second Life release builds,
signing, deployment, asset downloads, scheduled tag generation and external
notifications. They are **not** suitable as-is for OGL Viewer.

## Temporary action

Disable the **13 inherited GitHub Actions workflows** during source import.
The original workflow files are preserved in the imported Git history and the
pinned Firestorm upstream commit. Only `.github/workflows/foundation.yml`
remains active. This is not a C++ build.

## Required before enabling native OGL CI

1. Target `ReleaseOS` for Linux x64 and Windows x64 initially.
2. Explicitly review third-party dependencies, runners and license constraints.
3. Do not use Firestorm's signing keys, tokens, release channels or external
   endpoints. Inject OGL-owned secrets only after least-privilege review.
4. Eliminate unwanted scheduled, automatic signing, upload and deployment jobs.
5. Pin action dependencies, permissions and trusted asset sources.
6. Verify native compilation and launch + OpenSimulator login in test grid.
7. Keep publish/release workflows gated behind review and signed artifacts.

**Status:** Pending native CI implementation (#7).
