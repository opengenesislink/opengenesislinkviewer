# Building OGL Viewer (M1 source import branch)

**Important:** The draft source-import branch contains Firestorm C++ sources,
but the native OGL build has not been validated. The `main` branch still
lacks source code until PR #26 is accepted. Commands are test candidates.

## Linux x64 (initial target)

The upstream Linux build instructions target Ubuntu 22.04 x86_64, GCC 11,
16 GB+ RAM, 64 GB+ free disk space and a current `autobuild` tool.
Verify requirements against the *pinned* release branch and runner image.
Run `bash scripts/preflight_linux.sh` first on a dedicated Ubuntu 22.04 build machine to check toolchain, APT packages, architecture, glibc, memory and disk space.
See https://github.com/FirestormViewer/phoenix-firestorm/blob/Firestorm_7.2.4/doc/building_linux.md

Install prerequisites per upstream's Linux guide. Then:

```bash
git clone https://github.com/opengenesislink/opengenesislinkviewer.git
cd opengenesislinkviewer
git switch feature/firestorm-source-import
# Do not use main until PR #26 has been reviewed and merged.
git clone https://github.com/FirestormViewer/fs-build-variables.git ../fs-build-variables
git -C ../fs-build-variables checkout c17312d38377c003977cf5b6dcc83c6042eba194
bash scripts/preflight_linux.sh
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

For a local smoke build, check out `feature/firestorm-source-import` on an
**isolated build machine or VM**, not a workstation containing credentials.
GitHub Actions self-hosted runners execute code from the checked-out repository;
this is particularly hazardous for a **public** repository. Use a dedicated
non-root operating-system account without production secrets, isolate it from
sensitive networks, restrict who can dispatch native workflows, and do not run
unreviewed contributions on the native runner. The runner opens an outbound
HTTPS connection to GitHub; an inbound public SSH port is not needed for CI.

Initial Ubuntu 22.04 APT dependencies (from pinned upstream guide, with
`g++-11` and `python3-venv` explicitly included for this workflow):

```bash
sudo apt update
sudo apt install -y libgl1-mesa-dev libglu1-mesa-dev libpulse-dev \\
  build-essential python3-pip python3-venv git libssl-dev \\
  libxinerama-dev libxrandr-dev libfontconfig-dev libfreetype6-dev \\
  gcc-11 g++-11 cmake
```

For GitHub-managed builds, register a **repository-scoped** self-hosted runner
using the instructions displayed in GitHub > Repository Settings > Actions >
Runners > New self-hosted runner. Configure the custom runner label
`ogl-native-linux` on a dedicated Linux x64 runner. Never share the temporary
registration token in chat, source code or logs. This workflow can only be
manually dispatched via GitHub Actions after the workflow file exists on the
**default branch**; PR #26 remains draft and must not be merged merely to
trigger a workflow. In the meantime execute the local commands below on a
trusted checked-out copy of the import branch.

To perform the native build from the repository root:

```bash
git clone https://github.com/FirestormViewer/fs-build-variables.git ../fs-build-variables
git -C ../fs-build-variables checkout c17312d38377c003977cf5b6dcc83c6042eba194
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
export AUTOBUILD_VARIABLES_FILE="$(realpath ../fs-build-variables/variables)"
bash scripts/preflight_linux.sh
python3 scripts/check_source_import.py
bash scripts/build_linux.sh
bash scripts/check_linux_binary.sh
```

On a prepared checkout with a **previously successful CMake configure**, resume
an interrupted build without downloading or reconfiguring dependencies:
```bash
export PATH="/home/slmm/Projekte/opengenesislinkviewer/.venv/bin:$PATH" # example; use your own venv
export AUTOBUILD_VARIABLES_FILE="$(realpath ../fs-build-variables/variables)"
OGL_REUSE_CONFIG=1 OGL_BUILD_JOBS=3 bash scripts/build_linux.sh
```
The script checks `OPENSIM=ON` and `PACKAGE=OFF` in the CMake cache before
continuing. The explicit Ninja job limit is essential on memory-constrained
developer machines: `CMAKE_BUILD_PARALLEL_LEVEL` alone does **not** limit the
direct `ninja` subprocess launched by this Firestorm Autobuild configuration.

The local script requires the repository already be checked out at the import
branch. The optional `check_linux_binary.sh` verifies OpenSim CMake flags, a Linux x86_64 ELF executable, and missing dynamic libraries; it does **not** perform an OpenSimulator grid login. Successful compilation is **not** equivalent to runtime compatibility:
a launch and login test against an OpenSimulator-compatible test grid is still
required. Windows native CI remains outstanding under #7.

## Build artifact traceability

Release artifacts must record source SHA, upstream SHA, compiler, dependencies,
OS/runtime, ABI, OpenSim build target, feature flags, packaging format and test
matrix. Debug and update channels must have separate identities.
