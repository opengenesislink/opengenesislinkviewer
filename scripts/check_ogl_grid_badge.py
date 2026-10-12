#!/usr/bin/env python3
"""Static guards for the optional OGL discovery badge in Firestorm login UIs.

These are source/layout contracts, NOT a network or viewer runtime test.
"""
from pathlib import Path
import xml.etree.ElementTree as ET

root = Path(__file__).resolve().parent.parent
skins = root / "indra/newview/skins"
for skin in ("default", "starlight", "starlightcui"):
    for filename in ("panel_fs_login.xml", "panel_fs_nui_login.xml"):
        path = skins / skin / "xui/en" / filename
        ui = ET.parse(path).getroot()
        for name in ("server_combo", "ogl_grid_badge"):
            matched = [node for node in ui.iter() if node.attrib.get("name") == name]
            assert len(matched) == 1, f"{path}: expected one {name}"

code = (root / "indra/newview/fspanellogin.cpp").read_text(encoding="utf-8")
header = (root / "indra/newview/fspanellogin.h").read_text(encoding="utf-8")
for token in (
    '"/ogl/v1/grid-info"',
    '"org.opengenesislink.viewer.grid-info.v1"',
    'setFollowRedirects(false)',
    'setSSLVerifyPeer(true)',
    'setSSLVerifyHost(true)',
    "bytes.size() > 32768",
    '"OpenSim Legacy"',
    '"OGL verifiziert"',
    '"OGL erkannt (HTTP)"',
    "const bool tls = (scheme == \"https\")",
    "if (tls)",
    "mOglDiscoverySequence != sequence",
    "FSCoreHttpUtil::callbackHttpGetRaw(",
):
    assert token in code, f"missing badge security/source guard: {token}"
assert "onOglGridInfoResponse" in header
print("OGL v1 login badge layout and static fallback/security guards: PASS")
