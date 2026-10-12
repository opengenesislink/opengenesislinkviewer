#!/usr/bin/env bash
# SPDX-License-Identifier: LGPL-2.1-only
# Run a native OpenSimulator viewer from the staged tree with isolated user data.
# Does not register secondlife:// / hop:// desktop handlers.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP="$ROOT/build-linux-x86_64/newview/packaged"
BIN="$APP/bin/do-not-directly-run-firestorm-bin"
[[ -x "$BIN" && -d "$APP/lib" ]] || {
  echo "Build the native Linux ReleaseOS viewer before running this script." >&2
  exit 1
}

RUN="${OGL_TEST_ROOT:-$ROOT/ogl-runtime-test}"
[[ "$RUN" = /* ]] || { echo "OGL_TEST_ROOT must be absolute" >&2; exit 1; }
mkdir -p "$RUN"/{home,config,cache,data,state,logs,firestorm-x64-appdata}

# Current imported Firestorm code uses getpwuid(), not $HOME, and the
# Firestorm_x64 app-data name. This special override prevents any reads/writes
# from reaching the normal ~/.firestorm_x64 user settings or cache.
export FIRESTORM_X64_USER_DIR="$RUN/firestorm-x64-appdata"
export XDG_CONFIG_HOME="$RUN/config"
export XDG_CACHE_HOME="$RUN/cache"
export XDG_DATA_HOME="$RUN/data"
export XDG_STATE_HOME="$RUN/state"

# Save X11 authentication path before redirecting $HOME.
if [[ -n "${DISPLAY:-}" && -z "${XAUTHORITY:-}" && -f "$HOME/.Xauthority" ]]; then
  export XAUTHORITY="$HOME/.Xauthority"
fi
export HOME="$RUN/home"

# Firestorm's original launcher changes global desktop protocol registrations.
# Run the actual staged binary directly with its shipped shared libraries.
export LD_LIBRARY_PATH="$APP/lib:${LD_LIBRARY_PATH:-}"
export SDL_VIDEO_X11_DGAMOUSE=0
ulimit -c 0
cd "$APP"
echo "Starting OpenGenesisLINK viewer; all app data in $FIRESTORM_X64_USER_DIR"
exec "$BIN" "$@"
