# OGL NextGen Renderer — staged technical design

**Current baseline:** Firestorm renderer after upstream source import.
**Target:** improved performance and fidelity without sacrificing OpenSimulator
compatibility; a full Vulkan backend is a research program, not a quick swap.

## Stage R0: profile before refactor

Create representative scenes (city, crowded avatars, dense alpha foliage,
high-resolution meshes, interiors, night/PBR/water). Capture CPU/GPU frame times
(p50/p95/p99), stutters, VRAM high-water mark, texture fetch / upload, draw calls,
LOD transition rate and cold/warm cache. Record GPU/driver/OS and view settings.

## Stage R1: stabilize OpenGL

Refactor resource lifetime, threading seams, render pass inputs and shader
pipelines while keeping OpenGL functional. Preserve UI composite, alpha sorting,
meshes, rigged avatars, particles, shadows, media textures and PBR parity.
Optimize texture streaming, culling, batching and state changes first.

## Stage R2: backend abstraction

Proposed interfaces (subject to source audit): `RenderDevice`,
`FrameGraph`, `TextureResource`, `BufferResource`, `ShaderPipeline`,
`RenderPass`, `Swapchain`, `GpuProfiler`. Keep LLSD/world state separate
from GPU resources. Treat OpenGL as the reference backend.

## Stage R3: Vulkan feasibility

Proof of concept can draw terrain + basic meshes with synchronized camera
and assets. Compare CPU overhead and GPU driver support. Do not ship until
feature parity for avatars, transparency, PBR, terrain, post-effects and UI;
multi-platform driver test coverage and graceful fallback are demonstrated.

## Stage R4: advanced graphics

Evaluate TAA / FSR-like upscaling, better weather, volumetrics, real-time
reflections and raytraced effects by cost/quality metrics. Hardware RT must
be optional and not a grid requirement. Licenses for SDKs and algorithms
require separate approval.

## Acceptance

No "faster" claims without normalized test data. Define acceptable VRAM,
crash and p95 frame-time regression budgets before merging changes. Ship major
renderer paths behind flags with automatic fallback and crash diagnostics.

## Risks

High shader/driver matrix cost, alpha/transparency behavior, PBR compatibility,
Firestorm upstream churn, graphics SDK redistribution, GPU vendor gaps and
cross-platform UX rendering. Performance is scene- and GPU-specific.
