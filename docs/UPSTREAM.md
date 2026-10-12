# Firestorm upstream and source import policy

Source: https://github.com/FirestormViewer/phoenix-firestorm
Approved-for-initial-investigation release branch: `Firestorm_7.2.4`
Pinned commit: `10bd3c9f930c76e1427ddd4ecece6cdf36b4406d`.

Upstream states custom viewers should build on official release branches rather
than master (nightly) or preview. This pin does not imply a security audit.

## Why a source import instead of a GitHub "Fork" button?

The target repo already exists and contains foundation work. GitHub's fork
action is not provided by the project connector. The local helper imports a
release branch with **history**, preserving this repo's commits via an
unrelated-histories merge, then prepares a review branch. It is not a shallow
copy-and-paste of licensed C++ files.

## Import runbook

1. Review licenses, trademarks and build prerequisites.
2. Clone this repository and run `bash scripts/import_firestorm.sh`.
3. Review the merge result and the created `docs/UPSTREAM-README.md` copy.
4. Build `ReleaseOS` on Linux/Windows and document any changes.
5. Push the branch and open a PR with an attribution and dependency checklist.
6. After approval, merge. Never force-push `main`.

The import script cannot itself approve licenses, create binaries or validate
the OpenSim runtime. Import conflicts must be inspected and resolved manually.

## Future merges

Prefer `upstream` remote for imports, never blindly reset `main` to nightly.
For upstream updates: create PR -> note source SHA and security advisories ->
build compatibility suite -> compare OGL deltas -> approve and merge.

## Distribution

Keep upstream code attribution and applicable LGPL license, third-party
credits, modified-source availability obligations and distributable dependency
notices. Review all music/audio codecs, fonts, trademarked art and proprietary
SDKs. See [LEGAL.md](LEGAL.md).

## Imported CI workflows

Upstream GitHub Actions workflows (signing, deployment, schedules and SL builds)
were intentionally removed from the active `.github/workflows/` directory in
the reviewed import branch. Their contents remain recoverable via the pinned
upstream Git history. Reactivate a workflow only after inspecting its external
services, credentials, triggers and OpenSimulator `ReleaseOS` support.
See [CI_POLICY.md](CI_POLICY.md).
