#!/usr/bin/env bash
# OpenGenesisLINK Viewer: M1 Linux native ReleaseOS build environment gate.
# This validates prerequisites; it does not build a viewer.
set -euo pipefail

fail() { printf 'OGL Linux preflight FAILED: %s\n' "$*" >&2; exit 1; }

[[ -r /etc/os-release ]] || fail 'missing /etc/os-release'
# shellcheck disable=SC1091
source /etc/os-release
[[ "${ID:-}" == ubuntu && "${VERSION_ID:-}" == 22.04 ]] || fail 'Ubuntu 22.04 LTS is required'
[[ "$(uname -m)" == x86_64 ]] || fail 'x86_64 architecture is required'

for tool in gcc-11 g++-11 cmake python3 git dpkg-query getconf df awk; do
  command -v "$tool" >/dev/null 2>&1 || fail "missing tool: $tool"
done

# Upstream Firestorm 7.2.4 Linux guide, plus python3-venv for isolated Autobuild.
packages=(
  libgl1-mesa-dev libglu1-mesa-dev libpulse-dev build-essential
  python3-pip python3-venv git libssl-dev libxinerama-dev
  libxrandr-dev libfontconfig-dev libfreetype6-dev gcc-11 g++-11 cmake
)
missing=()
for pkg in "${packages[@]}"; do
  status=$(dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null || true)
  [[ "$status" == 'install ok installed' ]] || missing+=("$pkg")
done
if (( ${#missing[@]} > 0 )); then
  fail "missing APT packages: ${missing[*]} (install packages in docs/BUILD.md)"
fi

# Ubuntu 22.04 should supply glibc 2.35; assert minimum 2.34.
glibc=$(getconf GNU_LIBC_VERSION 2>/dev/null || true)
[[ "$glibc" =~ ^glibc[[:space:]]+([0-9]+)\.([0-9]+)$ ]] || fail "unknown glibc version: $glibc"
glibc_major=${BASH_REMATCH[1]}
glibc_minor=${BASH_REMATCH[2]}
(( glibc_major > 2 || (glibc_major == 2 && glibc_minor >= 34) )) || fail 'glibc >=2.34 required'

ram_kb=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
[[ "$ram_kb" =~ ^[0-9]+$ ]] || fail 'cannot determine system RAM'
(( ram_kb >= 15000000 )) || fail 'at least 16 GB RAM required'
free_mib=$(df -Pm . | awk 'NR==2 {print $4}')
[[ "$free_mib" =~ ^[0-9]+$ ]] || fail 'cannot determine available workspace disk space'
(( free_mib >= 65536 )) || fail 'at least 64 GiB free workspace disk required'

printf 'OGL Linux native preflight OK: %s %s; %s; RAM=%s KiB; disk=%s MiB; %s\n' \
  "$ID" "$VERSION_ID" "$(uname -m)" "$ram_kb" "$free_mib" "$glibc"
