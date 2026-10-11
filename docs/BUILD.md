# Building OGL Viewer (M1 source import branch)

**Important:** The draft source-import branch contains Firestorm C++ sources,
but the native OGL build has not been validated. The `main` branch still
lacks source code until PR #26 is accepted. Commands are test candidates.

## Linux x64 (initial target)

The upstream Linux build instructions target Ubuntu 22.04 x86_64, GCC 11,
16 GB+ RAM, 64 GB+ free disk space and a current `autobuild` tool.
Verify requirements against the *pinned* release branch and runner image.
See https://github.com/FirestormViewer/phoenix-firestorm/blob/Firestorm_7.2.4/doc/building_linux.md

Install prerequisites per upstream's Linux guide. Then:

```bash
git clone https://github.com/opengenesislink/opengenesislinkviewer.git
cd opengenesislinkviewer
# Requires M1: Firestorm source imported into this checkout first.
git clone https://github.com/FirestormViewer/fs-build-variables.git ../fs-build-variables
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
export AUTOBUILD_VARIABLES_FILE="$(realpath ../fs-build-variables/variables)"
autobuild configure -A 64 -c ReleaseOS
autobuild build -A 64 -c ReleaseOS
```

`ReleaseOS` is the upstream configuration for OpenSimulator without
non-default KDU/FMOD libraries. The exact instructions must be smoke-tested
against the pinned commit; neither running build nor packaging is yet verified.

## Windows x64 (initial target)

Use the upstream Windows build toolchain, Visual Studio and an appropriate
Python/Autobuild installation matching the pinned branch. The same `ReleaseOS`
configuration applies in upstream docs, with platform-specific environment
settings: https://github.com/FirestormViewer/phoenix-firestorm/blob/Firestorm_7.2.4/doc/building_windows.md

## CI policy

The **Foundation validation** GitHub Action checks documentation, JSON contracts,
shell/Python syntax, and a static Firestorm source-import/ReleaseOS guard.
It **does not** compile, package, or run the viewer.

The OGL-owned `.github/workflows/linux-releaseos.yml` workflow introduces an
opt-in **native Linux ReleaseOS compilation**. It has no release, signing,
deployment, publish, or updater step. It uploads only short-lived diagnostic
logs and source/build metadata, not a distributable installer.

Native build runner requirements:

- A **trusted, isolated**, self-hosted Linux x64 GitHub Actions runner carrying
  the custom label `ogl-native-linux`. Do not use this runner for untrusted PRs.
- Ubuntu 22.04, GCC/G++ 11, 16 GB+ RAM, 64 GiB+ free disk and the system
  packages described above in the pinned upstream guide.
- The workflow pins `FirestormViewer/fs-build-variables` to commit
  `c17312d38377c003977cf5b6dcc83c6042eba194`, and runs the checked-out
  OpenGenesisLINK source's `scripts/build_linux.sh` using `ReleaseOS`.
- The workflow uses only `workflow_dispatch`. GitHub exposes a manually
  triggered workflow in its Actions UI once its workflow file is present on
  the default branch. Because PR #26 is still **draft**, run the script
  locally on a prepared workstation to test this branch before merging.
  Do not merge solely to expose the manual workflow.

For a local smoke build, check out `feature/firestorm-source-import`,
install dependencies listed above, then from the repository root:

```bash
git clone https://github.com/FirestormViewer/fs-build-variables.git ../fs-build-variables
git -C ../fs-build-variables checkout c17312d38377c003977cf5b6dcc83c6042eba194
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
export AUTOBUILD_VARIABLES_FILE="$(realpath ../fs-build-variables/variables)"
python3 scripts/check_source_import.py
bash scripts/build_linux.sh
```

The local script requires the repository already be checked out at the import
branch. Successful compilation is **not** equivalent to runtime compatibility:
a launch and login test against an OpenSimulator-compatible test grid is still
required. Windows native CI remains outstanding under #7.

## Build artifact traceability

Release artifacts must record source SHA, upstream SHA, compiler, dependencies,
OS/runtime, ABI, OpenSim build target, feature flags, packaging format and test
matrix. Debug and update channels must have separate identities.
