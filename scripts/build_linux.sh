#!/usr/bin/env bash
# SPDX-License-Identifier: LGPL-2.1-only
# Explicit operator action only; requires already-imported Firestorm source.
set -euo pipefail

[[ -f autobuild.xml && -d indra && -f requirements.txt ]] || {
  echo "Firestorm sources missing: import M1 before building." >&2
  exit 1
}
command -v autobuild >/dev/null || {
  echo "Install Autobuild according to pinned Firestorm build instructions." >&2
  exit 1
}
[[ -n "${AUTOBUILD_VARIABLES_FILE:-}" ]] || {
  echo "Set AUTOBUILD_VARIABLES_FILE to fs-build-variables/variables" >&2
  exit 1
}
[[ -f "$AUTOBUILD_VARIABLES_FILE" ]] || {
  echo "AUTOBUILD_VARIABLES_FILE does not exist: $AUTOBUILD_VARIABLES_FILE" >&2
  exit 1
}

# The upstream ReleaseOS Autobuild configuration alone does NOT set OPENSIM=ON.
# Make OpenSimulator support and non-packaging explicit; validate CMakeCache so
# that a previously configured non-OpenSim viewer cannot silently pass CI.
CC_BIN=$(command -v "${CC:-gcc-11}") || { echo "gcc-11 not found" >&2; exit 1; }
CXX_BIN=$(command -v "${CXX:-g++-11}") || { echo "g++-11 not found" >&2; exit 1; }
autobuild configure -A 64 -c ReleaseOS -- \
  -DOPENSIM:BOOL=ON \
  -DPACKAGE:BOOL=OFF \
  -DCMAKE_C_COMPILER:FILEPATH="$CC_BIN" \
  -DCMAKE_CXX_COMPILER:FILEPATH="$CXX_BIN"

cache="build-linux-x86_64/CMakeCache.txt"
[[ -f "$cache" ]] || { echo "Missing CMakeCache: $cache" >&2; exit 1; }
grep -q '^OPENSIM:BOOL=ON "$cache" || {
  echo "OpenSimulator support was not enabled in $cache" >&2; exit 1;
}
grep -q '^PACKAGE:BOOL=OFF "$cache" || {
  echo "Packaging unexpectedly enabled in $cache" >&2; exit 1;
}
autobuild build -A 64 -c ReleaseOS --no-configure
