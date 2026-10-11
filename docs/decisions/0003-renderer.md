# ADR-0003: OpenGL parity before Vulkan

Status: **Proposed** — 2026-10-12.

Decision: retain upstream OpenGL as baseline while extracting render seams;
evaluate Vulkan as a separate feature-flagged backend only after benchmark and
feature-parity gates.

Trade-off: slower headline features, lower risk of breaking avatars/materials
or excluding older hardware.
