# Building OGL Viewer (M1 source import branch)

**M1 status (2026-10-12):** A complete Linux Mint 22.3 x86_64 native
`ReleaseOS` C++ build passed on a dedicated developer worktree (`OPENSIM=ON`,
`PACKAGE=OFF`). Staged ELF/linkage checks passed, the viewer opened its X11
GUI with isolated user settings, and an interactive Stadt NexVerse avatar
login subsequently completed through `STATE_STARTED`, confirmed both by the
user and the isolated viewer startup state log.
**Interactive inworld functionality (developer-confirmed, 2026-10-12):**
avatar rendering, inventory interaction, teleports, chat and LSL all worked.
Voice could not be tested because voice is not yet implemented on the
OpenGenesisLINK server. This is an untested server-dependent capability,
not a verified client failure. **The current tests do not qualify as an
Ubuntu 22.04 reference release build, Windows build, automated regression
suite, or secure production login.** The
import PR #26 remains a draft; `main` lacks imported source until review.

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
bash scripts/build_linux.sh
bash scripts/check_linux_binary.sh
```

`ReleaseOS` is the upstream configuration used for OpenSimulator without
non-default KDU/FMOD libraries. **Autobuild's ReleaseOS variant does not itself
enable OpenSimulator support**; the OGL script explicitly passes
`-DOPENSIM:BOOL=ON`, `-DVIEWER_CHANNEL:STRING=OpenGenesisLINK` and
`-DPACKAGE:BOOL=OFF`. Linux Mint 22.3 compilation has been verified;
Ubuntu 22.04 release reproducibility and installer packaging remain unverified.

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
a launch and login test against an OpenSimulator-compatible grid was
completed on the Mint development host; the Ubuntu 22.04 reference build,
Windows native CI under #7, product isolation, HTTPS grid access and release
signoff remain outstanding.

## Local isolated Linux GUI test (no credential transfer)

After a successful staged build and `bash scripts/check_linux_binary.sh`:

```bash
bash scripts/run_linux_isolated.sh
# If the grid is already configured in this *isolated* viewer profile:
bash scripts/run_linux_isolated.sh --grid hg.stadt-nexverse.de
```

The script uses a separate `ogl-runtime-test/` directory (or `OGL_TEST_ROOT`,
which must be an absolute path) for OpenGenesisLINK application settings,
cache, plugins and XDG data. M2 changed the native application data identity
to `OpenGenesisLINK_x64`, which defaults to `~/.opengenesislink_x64` on
Linux and never implicitly reuses `~/.firestorm_x64`. The **critical**
Linux test override is now `OPENGENESISLINK_X64_USER_DIR`: the underlying
viewer gets the OS home from `getpwuid()`, **not** from `HOME`, so modifying
`HOME` alone does not fully isolate a test run. Do **not** launch the staged
`firestorm` wrapper for isolation tests: upstream's wrapper also registers
system URL protocol handlers at startup. Use the OGL test script, which
invokes the staged executable directly with bundled library paths.

The first developer workstation smoke test identified the home-directory
behavior and, before isolation was corrected, briefly wrote user settings and
purged cache entries in the host Firestorm profile. No automatic restoration
of those host files was performed. Subsequent runs confirmed writes only to
the then-isolated `ogl-runtime-test/firestorm-x64-appdata` tree (pre-M2); new test sessions instead use `ogl-runtime-test/opengenesislink-x64-appdata` and an unchanged
host settings-file timestamp. Never copy a real account's password, token or
credential into the isolated profile; only public grid metadata may be used.

The successful GUI startup reached `STATE_BROWSER_INIT --> STATE_LOGIN_SHOW
--> STATE_LOGIN_WAIT`, with the native OpenGenesisLINK title shown and no
automatic login. This validates application launch and the login screen,
**not** authenticating or entering a test region; that requires a
credentialed, manually supervised OpenSimulator smoke test.

**Subsequent authenticated login smoke, 2026-10-12:** After the initial
pre-login smoke, the developer signed into Stadt NexVerse successfully. The
isolated `Firestorm.log` recorded the transitions `STATE_LOGIN_WAIT` through
`STATE_LOGIN_PROCESS_RESPONSE`, `STATE_WORLD_INIT`, `STATE_SEED_CAP_GRANTED`,
`STATE_AGENT_SEND`, `STATE_INVENTORY_SKEL`, `STATE_PRECACHE`, and finally
`STATE_STARTED`. The viewer remained running. The developer subsequently confirmed
successful avatar rendering, inventory interactions, teleporting, chat and
LSL inworld (manual tests on 2026-10-12). Voice **cannot currently be
validated end-to-end** because the OpenGenesisLINK server does not yet
provide voice; this must be revisited when the backend becomes available. No login credentials or complete authentication
log lines were copied into this repository. **The HTTP-only grid endpoint
remains a security concern despite this functional login success.**

For the Stadt NexVerse endpoint found in the developer workstation's saved
public grid metadata, `http://hg.stadt-nexverse.de/get_grid_info` returned
HTTP 200, but an HTTPS request to port 443 could not connect on
2026-10-12. **Do not enter production avatar passwords over an unencrypted
HTTP login endpoint.** Configure a working TLS endpoint first or, if protocol
compatibility testing is essential, use a disposable test account with no
privileges and no reused credentials. No password was imported from the
original profile, and no avatar login was attempted during this M1 smoke.

## Build artifact traceability

Release artifacts must record source SHA, upstream SHA, compiler, dependencies,
OS/runtime, ABI, OpenSim build target, feature flags, packaging format and test
matrix. Debug and update channels must have separate identities.
