# HydroEngine visual integration — proposed

The authoritative hydrology/physics model runs server-side in OGL C# region
modules. The viewer renders negotiated water state and may predict only
cosmetic motion; it cannot directly mutate water volume/terrain authority.

## Candidate data

Versioned snapshots: region/coordinate frame, water bodies, surface level,
velocity field, flow direction, quality/foam attributes, simulation tick,
timestamp and bounded delta sequence. Use LOD/budget policies for large
terrain areas, strong compression and cache invalidation.

## Lifecycle

Negotiate feature -> receive initial snapshot -> render mesh/surface ->
apply ordered deltas -> detect gaps and resnapshot -> reset on teleport
or simulator change. If disabled/unavailable: standard Firestorm/OpenSim
water rendering. Never require HydroEngine to login or enter a region.

## Acceptance

Simulation and rendering must be decoupled, predictable under packet loss,
safe on region crossing, bounded in memory and visually useful without
hardware ray tracing. Water edit permissions must be server-side.
