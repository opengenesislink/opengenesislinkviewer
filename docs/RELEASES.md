# Version and release process

No downloadable OGL Viewer release exists at foundation stage.

## Channels (proposal)

- `Developer`: internal debug / experiment, separate settings/cache.
- `Preview`: opt-in testers, signed build and crash triage.
- `Stable`: all acceptance gates, upgraded rollback validation.

Every installer must have a distinct application ID from Firestorm, update
feed, icon/name, profile path and cache location. Code-sign release artifacts,
verify signatures during update, preserve a trusted rollback path and publish
SHA-256 checksums.

Release note checklist: supported OS/driver, build SHA, upstream baseline,
feature flags, protocol compatibility, migrations, known issues, dependencies,
third-party attribution, security and data handling changes.
