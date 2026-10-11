#!/usr/bin/env python3
"""Validate foundation project files; NOT a C++ compile/test suite."""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ERRORS: list[str] = []

def need(cond: bool, message: str) -> None:
    if not cond:
        ERRORS.append(message)

def load(rel: str):
    path = ROOT / rel
    need(path.is_file(), f"missing: {rel}")
    if not path.is_file():
        return None
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (ValueError, OSError) as exc:
        ERRORS.append(f"invalid JSON {rel}: {exc}")
        return None

def main() -> int:
    required = [
        "README.md", "ROADMAP.md", "CONTRIBUTING.md",
        "docs/PROJECT_STATUS.md", "docs/ARCHITECTURE.md",
        "docs/PROTOCOL.md", "docs/BUILD.md", "docs/RENDERER.md",
        "docs/UPSTREAM.md", "docs/COMPATIBILITY.md", "docs/LEGAL.md",
        "docs/QA.md", "docs/ECONOMY.md", "docs/HYDROENGINE.md",
        "docs/SEARCH_UI.md", "docs/RELEASES.md", "docs/SECURITY.md",
        "scripts/import_firestorm.sh", "scripts/build_linux.sh"
    ]
    for rel in required:
        need((ROOT / rel).is_file(), f"missing: {rel}")
    upstream = load("config/upstream.json")
    manifest = load("config/ogl-features.example.json")
    schema = load("config/ogl-features.schema.json")
    if upstream:
        need(upstream.get("commit") == "10bd3c9f930c76e1427ddd4ecece6cdf36b4406d",
             "unexpected pinned Firestorm SHA")
        need(upstream.get("build_variant") == "ReleaseOS", "wrong OpenSim variant")
    if schema and manifest:
        need(manifest.get("protocol") == schema["properties"]["protocol"]["const"],
             "protocol mismatch")
        need(manifest.get("protocolVersion") == schema["properties"]["protocolVersion"]["const"],
             "version mismatch")
        need(bool(re.fullmatch(r"[0-9a-fA-F-]{36}", manifest.get("regionId", ""))),
             "example regionId not UUID-shaped")
        need(set(manifest) == set(schema.get("required", [])), "manifest root fields changed")
        allowed = set(schema["properties"]["features"]["properties"])
        need(set(manifest.get("features", {})).issubset(allowed), "unknown feature")
        for name, feature in manifest.get("features", {}).items():
            need(set(feature) == {"version", "available"}, f"invalid feature {name}")
            need(feature.get("version") == "0.1", f"version error {name}")
            need(type(feature.get("available")) is bool, f"availability not boolean {name}")
    # Resolve relative Markdown links in docs. Ignore URLs, mailto, anchors and images.
    link_re = re.compile(r"(?<!!)\[[^\]]+\]\(([^)]+)\)")
    for source in list(ROOT.glob("*.md")) + list((ROOT / "docs").rglob("*.md")):
        for target in link_re.findall(source.read_text(encoding="utf-8")):
            link = target.split("#", 1)[0]
            if not link or link.startswith(("https://", "http://", "mailto:")):
                continue
            if " " in link:
                link = link.split(" ", 1)[0]
            destination = (source.parent / link).resolve()
            need(destination.is_relative_to(ROOT) and destination.exists(),
                 f"{source.relative_to(ROOT)}: unresolved link {target}")
    for msg in ERRORS:
        print("ERROR:", msg, file=sys.stderr)
    if ERRORS:
        print(f"Foundation FAILED: {len(ERRORS)} problem(s)", file=sys.stderr)
        return 1
    print("Foundation OK (docs and protocol proposal only; native viewer NOT built).")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
