# Legal and licensing checklist (review required)

Upstream Firestorm repository publishes its viewer source under **LGPL-2.1**.
The source tree can include files under additional licenses. A future OGL
distribution must comply with the applicable license for each component.
This document is a checklist, not legal advice.

## Before source import

- [ ] Review upstream LICENSE and file-level SPDX/header copyright notices.
- [ ] Record the pinned upstream SHA, source URL and modified files.
- [ ] Inventory third-party source and binary dependencies (licenses/obligations).
- [ ] Validate Firestorm branding/logo/trademarks are NOT reused as OGL identity.
- [ ] Validate Linden Lab/Second Life legal notices and attribution.
- [ ] Decide licensing headers for newly authored OGL C++ and tools.

## Before binary distribution

- [ ] Publish corresponding source and modification notices as required.
- [ ] Include applicable license texts and third-party notices.
- [ ] Evaluate codec, KDU, FMOD, fonts, media and SDK redistribution rights.
- [ ] Verify signing, update system, privacy, third-party services and telemetry.
- [ ] Check compatibility with applicable third-party viewer policies.
- [ ] Run a legal review for release and distribution locales.

Do not claim licensing as complete solely because the upstream README says
LGPL. The license file is brought with the upstream source in M1.
