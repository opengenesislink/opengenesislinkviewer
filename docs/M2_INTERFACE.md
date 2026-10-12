# OpenGenesisLINK Viewer M2: native edge navigation

**Status:** first implementation in `feature/firestorm-source-import`.  
**Goal:** a modern, non-destructive UI layer above the existing Firestorm
floater registry; do not replace working inventory, chat or teleport code.

## Inworld sidebars

The viewer creates two overlays after `LLViewerWindow::initWorldUI()`.
On the login screen and in noninteractive runs they are not instantiated.
Both start collapsed by default; click the chevron at either screen edge to
expand or collapse. The state is saved independently for each side via the
existing `gSavedSettings` configuration.

| Left: MEIN NEXVERSE | Existing floater |
| --- | --- |
| Inventar | `inventory` |
| Avatar & Outfits | `appearance` |
| Kontakte & Gruppen | `people` |
| Chat | `fs_nearby_chat` |

| Right: WELT & WERKZEUGE | Existing floater |
| --- | --- |
| Weltkarte | `world_map` |
| Minikarte | `mini_map` |
| Bauen | `build` |
| Einstellungen | `preferences` |

The menus use opaque slate-blue panels and pale-blue titles. They preserve
the complete world viewport (no camera resizing), so they can overlap the
world. Buttons toggle **existing** registered floaters. They do not replace
toolbars, hide required controls, change authentication or reimplement
underlying UI functions.

## Settings

Declared in `indra/newview/app_settings/settings.xml`:

- `OGLSidebarsEnabled=true`: allow the optional inworld menus;
- `OGLLeftSidebarExpanded=false`: the left menu starts collapsed;
- `OGLRightSidebarExpanded=false`: the right menu starts collapsed.

All values are persistent, user-scoped and independently editable in
advanced viewer settings. The GUI is repositioned on window resize.

## Validation and limitations

Static source/setting guard: `python3 scripts/check_ogl_edge_sidebars.py`
(runs in Foundation CI). Build using
`OGL_REUSE_CONFIG=1 OGL_BUILD_JOBS=3 bash scripts/build_linux.sh` on the
Linux developer machine. The normal login regression is protected by not
instantiating overlays before `initWorldUI`.

**Manual inworld checks still required** after the new build:
1. Log in and confirm both closed tabs at the left and right edges.
2. Open and close each side; restart viewer to confirm stored state.
3. Use all eight action buttons, including across region teleport.
4. Resize and maximize window; test focus, mouse, mouselook, screen
   resolution and overlap with other floaters.
5. Set `OGLSidebarsEnabled=false` in test settings and restart to confirm
   the original Firestorm UI is unchanged.
6. Confirm no regression to grid selection/login, inventory/chat, or
   OpenSimulator and Firestorm-compatible behavior.

These first menus are **native and functional** but do not yet feature
animated drawers, icon artwork, user-editable item order, mobile/touch
navigation, per-theme visual tuning or keyboard shortcuts. Those are
subsequent M2 iterations, not features claimed complete here.

## Product identity

M2 is not complete until the default application data, executable and
packaging identities, icons, desktop URL handlers, Windows installer
and per-account paths are independent from original Firestorm. The
isolated Linux test launcher currently uses a Firestorm upstream override;
this must be removed as the final product data directory is adopted.
