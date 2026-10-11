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

autobuild configure -A 64 -c ReleaseOS
autobuild build -A 64 -c ReleaseOS --no-configure
