# Building OGL Viewer (after source import)

**Important:** The current foundation repository contains no Firestorm C++
source. Commands below will not compile a viewer until the M1 import is merged.

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

Foundation GitHub Actions validates Markdown links and JSON contracts ONLY.
Native Linux/Windows CI must be introduced after the source import and runner
resource audit; a green foundation badge never means a binary was built.

## Build artifact traceability

Release artifacts must record source SHA, upstream SHA, compiler, dependencies,
OS/runtime, ABI, OpenSim build target, feature flags, packaging format and test
matrix. Debug and update channels must have separate identities.
