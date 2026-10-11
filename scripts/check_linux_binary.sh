#!/usr/bin/env bash
# OpenGenesisLINK Viewer M1: ELF/linkage smoke check; does NOT test simulator login.
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
build="${1:-$root/build-linux-x86_64}"
cache="$build/CMakeCache.txt"

fail() { echo "OGL binary smoke check FAILED: $*" >&2; exit 1; }
[[ -r "$cache" ]] || fail "missing CMake cache: $cache"
grep -qx 'OPENSIM:BOOL=ON' "$cache" || fail 'OpenSimulator support disabled in CMakeCache'
grep -qx 'PACKAGE:BOOL=OFF' "$cache" || fail 'unexpected packaging in M1 test build'
grep -qx 'VIEWER_CHANNEL:STRING=OpenGenesisLINK' "$cache" || fail 'unexpected Viewer channel'
command -v readelf >/dev/null || fail 'readelf not found (install binutils)'
command -v ldd >/dev/null || fail 'ldd not found'

binary="$build/newview/firestorm-bin"
if [[ ! -f "$binary" ]]; then
  binary=$(find "$build/newview" -maxdepth 3 -type f -name 'firestorm-bin' -print -quit 2>/dev/null || true)
fi
[[ -n "$binary" && -f "$binary" ]] || fail 'no compiled firestorm-bin executable; native build incomplete'
[[ -x "$binary" ]] || fail "not executable: $binary"
readelf -h "$binary" | grep -q 'ELF64' || fail 'binary is not ELF64'
readelf -h "$binary" | grep -Eq 'Machine:.*(X86-64|Advanced Micro Devices X86-64)' || fail 'binary is not x86_64'

echo "OpenSim flags/channel OK; ELF x86_64 executable: $binary"
echo "Dynamic library dependencies:"
deps=$(ldd "$binary" 2>&1) || { printf '%s\n' "$deps"; fail 'ldd inspection failed'; }
printf '%s\n' "$deps"
if printf '%s\n' "$deps" | grep -q 'not found'; then
  fail 'missing runtime shared library; inspect ldd output'
fi
echo 'OGL binary smoke check OK (ELF/linkage only; OpenSimulator login remains untested).'
