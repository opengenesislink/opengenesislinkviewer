# Feature flag policy (proposal)

Flags are disabled unless a compatible authenticated region capability
is advertised and the user's policy permits the feature.

| Flag | Default | Prerequisite |
| --- | --- | --- |
| ogl.search | off | advertised search capability |
| ogl.wallet | off | wallet CAP and security review |
| ogl.marketplace | off | trusted marketplace integration |
| ogl.hydro | off | Hydro CAPS and renderer support |
| ogl.terrain_stream | off | negotiated terrain protocol |
| ogl.federation | off | federation identity and privacy review |
| ogl.render.vulkan | off | Vulkan parity/perf gates |
| ogl.render.raytracing | off | optional Vulkan backend and GPU support |

Reset region-bound features and their session URLs on region change.
User toggles never override server authorization, disabled capability
versions, legal restrictions or security safeguards.
