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
# The foundation and upstream can both add .gitignore and LICENSE, and -X ours
# does not always resolve add/add conflicts. Only these KNOWN files are handled
# automatically; unexpected conflicts remain for a human to review.
if ! git merge --allow-unrelated-histories --no-ff -X ours \
  -m "chore: merge OGL foundation into pinned Firestorm $BASELINE" origin/main; then
  conflicts="$(git diff --name-only --diff-filter=U)"
  [[ -n "$conflicts" ]] || die "Merge failed without file conflicts; inspect git status."

  had_gitignore=false
  while IFS= read -r path; do
    case "$path" in
      LICENSE)
        # The upstream license is the authoritative baseline.
        git checkout --ours -- LICENSE
        git add -- LICENSE
        ;;
      .gitignore)
        # Keep upstream build ignores and then append OGL foundation ignores.
        git checkout --ours -- .gitignore
        had_gitignore=true
        ;;
      *)
        die "Unexpected conflict: $path. Resolve manually and finish the merge."
        ;;
    esac
  done <<< "$conflicts"

  if [[ "$had_gitignore" == "true" ]]; then
    printf '\n# OGL foundation ignores\n' >> .gitignore
    git show origin/main:.gitignore >> .gitignore
    git add -- .gitignore
  fi
  [[ -z "$(git diff --name-only --diff-filter=U)" ]] ||
    die "Unresolved merge conflicts remain."

  git commit -m "chore: merge OGL foundation into pinned Firestorm $BASELINE"
fi

# Preserve project-facing entry points; upstream docs remain available separately.
mkdir -p docs
git show "upstream/$BASELINE:README.md" > docs/UPSTREAM-README.md
if git cat-file -e "upstream/$BASELINE:CONTRIBUTING.md" 2>/dev/null; then
  git show "upstream/$BASELINE:CONTRIBUTING.md" > docs/UPSTREAM-CONTRIBUTING.md
fi
git checkout origin/main -- README.md ROADMAP.md CONTRIBUTING.md .github/pull_request_template.md
git add README.md ROADMAP.md CONTRIBUTING.md .github/pull_request_template.md docs/UPSTREAM-README.md
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
