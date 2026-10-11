#!/usr/bin/env bash
# SPDX-License-Identifier: LGPL-2.1-only
# PREPARES a local review branch. Never pushes or force-pushes.
set -euo pipefail

BASELINE="Firestorm_7.2.4"
PIN="10bd3c9f930c76e1427ddd4ecece6cdf36b4406d"
BRANCH="feature/firestorm-source-import"
UPSTREAM="https://github.com/FirestormViewer/phoenix-firestorm.git"

die() { echo "ERROR: $*" >&2; exit 1; }
git rev-parse --show-toplevel >/dev/null || die "Run inside OGL git clone"
[[ -f ROADMAP.md && -f config/upstream.json ]] || die "Run at OGL repository root"
[[ -z "$(git status --porcelain)" ]] || die "Working tree must be clean"
[[ "$(git branch --show-current)" == "main" ]] || die "Start from the main branch"
git fetch origin main || die "Cannot fetch the OGL main branch"
[[ "$(git rev-parse HEAD)" == "$(git rev-parse origin/main)" ]] || die "Your main must match origin/main"
if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  die "Branch $BRANCH already exists; inspect it instead of overwriting"
fi
if git remote get-url upstream >/dev/null 2>&1; then
  [[ "$(git remote get-url upstream)" == "$UPSTREAM" ]] || die "Existing upstream remote has a different URL"
else
  git remote add upstream "$UPSTREAM"
fi
echo "Fetching pinned official release (may require significant disk/network)..."
git fetch --no-tags upstream "refs/heads/$BASELINE:refs/remotes/upstream/$BASELINE"
ACTUAL="$(git rev-parse "refs/remotes/upstream/$BASELINE")"
[[ "$ACTUAL" == "$PIN" ]] || die "Upstream release moved! Expected $PIN, got $ACTUAL; review before import"

git switch -c "$BRANCH" "upstream/$BASELINE"
# Different repository ancestry: merge BOTH histories without discarding upstream.
# In rare file collisions prefer upstream C++ source and inspect the merge diff.
git merge --allow-unrelated-histories --no-ff -X ours \
  -m "chore: merge OGL foundation into pinned Firestorm $BASELINE" origin/main

# Preserve project-facing entry points; upstream docs remain available separately.
mkdir -p docs
git show "upstream/$BASELINE:README.md" > docs/UPSTREAM-README.md
if git cat-file -e "upstream/$BASELINE:CONTRIBUTING.md" 2>/dev/null; then
  git show "upstream/$BASELINE:CONTRIBUTING.md" > docs/UPSTREAM-CONTRIBUTING.md
fi
git checkout origin/main -- README.md ROADMAP.md CONTRIBUTING.md
git add README.md ROADMAP.md CONTRIBUTING.md docs/UPSTREAM-README.md
if [[ -f docs/UPSTREAM-CONTRIBUTING.md ]]; then
  git add docs/UPSTREAM-CONTRIBUTING.md
fi
if ! git diff --cached --quiet; then
  git commit -m "docs: retain OGL project entry points and upstream attribution"
fi

echo
echo "Prepared: $BRANCH"
echo "IMPORTANT: review entire tree, licensing, dependency notices and builds."
echo "Next: git diff --stat origin/main...HEAD"
echo "Next: python3 scripts/check_scaffold.py"
echo "After review ONLY: git push -u origin $BRANCH"
echo "Then open a GitHub PR to main. No push occurred."
