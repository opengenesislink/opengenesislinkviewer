# Security policy (planning stage)

No shipped executable currently exists; no bounty, SLA or guaranteed support
response is represented.

For security concerns do not disclose sensitive data in public GitHub Issues.
Use GitHub's private security advisory/reporting capability if enabled by
repository administrators, or contact the project operator through an
independently verified official channel. Do not post credentials or live
capability URLs.

Threat model requirements: untrusted remote regions, malicious parcels/LLSD,
exploitable media, viewer update supply chain, asset decompression, wallet
authorization, redirect / token disclosure, sandboxing of embedded browsers,
session fixation and cross-grid identity.

Never include production payment operations without replay defense,
rate limiting, independent server authorization and tested rollback/audit.
