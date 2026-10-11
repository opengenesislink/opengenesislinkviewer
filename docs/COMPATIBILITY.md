# OpenSimulator / Hypergrid compatibility requirements

## Matrix to validate after source import

| Scenario | Standard OpenSimulator | OGL Simulator |
| --- | --- | --- |
| Login / logout / grid manager | Required | Required |
| Region crossing / teleport | Required | Required |
| Inventory / attachments / appearance | Required | Required |
| Mesh / PBR / textures / animations | Required | Required |
| LSL chat / dialog / media | Required | Required |
| Voice | Existing behavior where supported | Negotiated optional extension |
| Economy | Server-advertised legacy mechanism | Optional NV$ integration |
| Search | Existing available fallback | Optional OGL search |
| Terrain / water | Standard static/client behavior | Optional Hydro/terrain extension |
| Hypergrid transfer | Existing compatible behavior | Optional federated enhancements |

## Rules

- Do not alter baseline network semantics just to enable OGL-only features.
- Detect region-specific services on every entry/crossing; there can be different
  simulators and feature sets on adjacent regions.
- Test against at least one stock OpenSimulator instance and one current OGL
  test instance before qualifying any interoperability claim.
- Keep permission and inventory authority on the server.
- Do not assume variable regions, mesh features or scripted debit are universal.
- When extensions are not advertised, the viewer continues without errors.
