#!/usr/bin/env python3
"""Static import guard. A successful result is NOT a native viewer build."""
from pathlib import Path
import sys
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]

def fail(message: str) -> None:
    raise SystemExit(f"Source preflight FAILED: {message}")

for name in (
    "LICENSE",
    "autobuild.xml",
    "requirements.txt",
    "indra/newview/CMakeLists.txt",
    "doc/building_linux.md",
):
    if not (ROOT / name).is_file():
        fail(f"missing upstream file: {name}")

try:
    root = ET.parse(ROOT / "autobuild.xml").getroot()
except (ET.ParseError, OSError) as exc:
    fail(f"invalid autobuild.xml: {exc}")

configs = []
for parent in root.iter("map"):
    nodes = list(parent)
    for index, node in enumerate(nodes[:-1]):
        if node.tag == "key" and node.text == "ReleaseOS" and nodes[index + 1].tag == "map":
            configs.append([s.text or "" for s in nodes[index + 1].iter("string")])
if not configs:
    fail("ReleaseOS configuration not found")
if not any("-DINSTALL_PROPRIETARY=FALSE" in opts for opts in configs):
    fail("ReleaseOS lacks the expected non-proprietary build switch")

expected = {"foundation.yml", "linux-releaseos.yml"}
active = {p.name for p in (ROOT / ".github/workflows").iterdir()
          if p.suffix in {".yml", ".yaml"}}
if not active.issubset(expected):
    fail("unreviewed workflow files: " + ", ".join(sorted(active - expected)))
if "foundation.yml" not in active:
    fail("OGL foundation workflow missing")

print(f"Source preflight OK: {len(configs)} ReleaseOS variant(s), no inherited active workflows.")
print("NOT a native C++ compilation or OpenSimulator login test.")
