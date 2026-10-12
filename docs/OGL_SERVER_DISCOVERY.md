# OpenGenesisLINK server JSON discovery – viewer integration contract

**Recorded:** 2026-10-12  
**Server repository:** `opengenesislink/opengenesislinkserver`  
**Server specification:** [OGL_VIEWER_DISCOVERY.md](https://github.com/opengenesislink/opengenesislinkserver/blob/main/doc/NexVerse/OGL_VIEWER_DISCOVERY.md)  
**Initial server implementation:** [commit `3f8669847a8e`](https://github.com/opengenesislink/opengenesislinkserver/commit/3f8669847a8eb0caedca52f04d723dedd4069f72)

## Status / compatibility boundary

The server has introduced a **public, unauthenticated, optional** discovery endpoint:

```http
GET /ogl/v1/grid-info
Accept: application/json
```

It is served by the existing public ROBUST listener, alongside:
- `GET /get_grid_info` (existing XML grid info);
- `GET /json_grid_info` (existing JSON grid info);
- legacy XML-RPC `login_to_simulator`, LLSD login and the existing CAPS.

**Do not treat JSON discovery as a login or as proof of client identity.**
Server JSON announces `features.ogl_native_login=false` and
`endpoints.ogl_login=null`; do not send credentials to the discovery path
or invent/enable `POST /ogl/v1/login`. The legacy login and old Firestorm
grid-info paths must continue to work without changes.

**Observed deployment probe on 2026-10-12 (developer workstation):**
`http://hg.stadt-nexverse.de/ogl/v1/grid-info` replied **HTTP 404**.
`/get_grid_info` and `/json_grid_info` both replied **HTTP 200**.
The GitHub server code/specification is present, but this is **not evidence
that the live service has been redeployed**. Do not claim the endpoint is
publicly available until a post-deployment GET succeeds.

## Expected v1 response contract

```text
schema                                  "org.opengenesislink.viewer.grid-info.v1"
protocol_version                        1
server.product                          "OpenGenesisLINK"
server.version                          string
grid.name / grid.nick                   public strings
grid.home_uri / grid.gatekeeper_uri     public valid URLs or null
grid.website                            public URL or null
endpoints.legacy_login                  public URL (subject to validation)
endpoints.legacy_grid_info              "/get_grid_info"
endpoints.legacy_grid_info_json         "/json_grid_info"
endpoints.ogl_grid_info                 "/ogl/v1/grid-info"
endpoints.ogl_login                     null (until implemented and tested)
features.legacy_login                   true
features.ogl_grid_info_v1               true
features.ogl_native_login               false
features.ogl_experiences_2              false
features.ogl_pathfinding_2              false
features.ogl_my_outfits_2               false
security.discovery_is_public            true
security.tls_required_for_credentials   true
security.viewer_identity_verified_by_discovery false
```

Server example values such as `grid.name` are illustrative and **must not**
be hard-coded into the client. Unknown future feature flags are disabled by
default; do not enable functionality merely because a key is present.

## Proposed OGL viewer implementation (NOT YET CODED)

Primary existing Firestorm/OpenSimulator grid discovery:
`indra/newview/fsgridhandler.cpp` currently obtains `/get_grid_info`
using `FSCoreHttpUtil::callbackHttpGetRaw`. Preserve that working behavior.

1. For grids selected by the user, initiate an **optional** GET for the
   versioned OGL JSON contract. Do not assume third-party grids implement it.
2. Accept only a successfully parsed bounded JSON document whose exact
   `schema` and `protocol_version` match the supported v1. Validate
   field types and reject malformed/oversized/unexpected responses. A
   404, timeout, invalid JSON, unsupported version or other error is
   **non-fatal**: retain standard Firestorm/OpenSimulator grid discovery.
3. Expose successfully negotiated OGL capabilities to future OGL-specific
   UI components without mutating or replacing the standard
   `login_to_simulator` and CAPS routes. Keep one authoritative login
   session and avatar identity.
4. Never infer the authenticity of the viewer or authorize a privileged
   action from `server.product`, the viewer's channel, `User-Agent`,
   IP address or public discovery data. Gate OGL-specific actions through
   server-authorized authenticated session/CAPS.
5. Do not downgrade HTTPS to HTTP for a credential-bearing request.
   Validate scheme, host, redirect and embedded URL credentials before
   trusting advertised URLs; do not permit untrusted JSON to cause
   requests carrying credentials to arbitrary hosts. The NexVerse
   development grid currently advertises an HTTP login URI; that remains
   an explicit **security release blocker**.
6. When the server eventually implements a dedicated native login,
   negotiate it only after `features.ogl_native_login=true`,
   a non-null URL, TLS validation and completed end-to-end tests. Until
   then, keep the native-login switch hard-disabled.

Suggested tests before claiming viewer support:
- v1 JSON present: parse exact schema/flags, retain functional legacy login;
- OGL path returns HTTP 404 (the currently deployed case): clean fallback;
- server returns malformed or future v2 JSON: safe fallback;
- misleading/credential-bearing/foreign-origin URL: reject;
- server flags native login off/null: **no native login attempt**;
- old OpenSimulator and Firestorm grids still log in normally;
- no secrets or full authentication payloads in client diagnostic logs.

**Current viewer state:** native Linux `ReleaseOS` compiled and logged in
successfully via the legacy-compatible path; OGL v1 JSON negotiation is
**not yet implemented**. This document is the integration handoff,
not a claim of an implemented client capability.
