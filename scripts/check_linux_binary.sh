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

# The staged application bundles WebRTC, OpenAL utilities and other libraries.
# Check its real launcher target with the same library directory used by the
# shipped launcher, not the un-staged raw linker output.
stage="$build/newview/packaged"
binary="$stage/bin/do-not-directly-run-firestorm-bin"
[[ -f "$binary" ]] || fail "staged viewer executable missing: $binary"
[[ -d "$stage/lib" ]] || fail "staged runtime libraries missing: $stage/lib"
[[ -x "$binary" ]] || fail "not executable: $binary"
readelf -h "$binary" | grep -q 'ELF64' || fail 'binary is not ELF64'
readelf -h "$binary" | grep -Eq 'Machine:.*(X86-64|Advanced Micro Devices X86-64)' || fail 'binary is not x86_64'

echo "OpenSim flags/channel OK; staged ELF x86_64 executable: $binary"
echo "Staged dynamic library dependencies:"
deps=$(LD_LIBRARY_PATH="$stage/lib:${LD_LIBRARY_PATH:-}" ldd "$binary" 2>&1) || {
  printf '%s\n' "$deps"; fail 'ldd inspection failed'
}
printf '%s\n' "$deps"
if printf '%s\n' "$deps" | grep -q 'not found'; then
  fail 'missing runtime shared library; inspect staged ldd output'
fi
echo 'OGL binary smoke check OK (ELF/linkage only; OpenSimulator login remains untested).'
