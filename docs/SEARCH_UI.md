# Search, UX and Creator Studio

## OGL Search

Search must retain a familiar UI for avatars, regions, events, classifieds
and objects while supporting OGL search results via a trusted capability.
No hardcoded production account identifiers or unrestricted browsing from
privileged embedded web contexts. Non-OGL grids fall back to supported
legacy flows.

Candidate service host: search.stadt-nexverse.de (configuration, not a
live-availability guarantee). Explicitly separate external web content and
native viewer permissions.

## Modern UI

Proposed consistent navigation, theme tokens, resizable/dockable layouts,
keyboard/screen-reader accessibility, German and English localization,
first-run onboarding and settings migration.

## Creator Studio

Iterative tooling on top of existing prim/mesh workflows: inspector,
alignment, linked-set editing, improved script editor and per-object
diagnostics. Existing permissions and object ownership stay authoritative
server-side. Avoid duplicating Firestorm feature implementations.
