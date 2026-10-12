#!/usr/bin/env python3
"""M2 source guard for persistent, collapsible left/right OGL inworld menus.

Only static checks: the runtime inworld rendering requires a real grid login.
"""
from pathlib import Path
import xml.etree.ElementTree as ET

root = Path(__file__).resolve().parent.parent
settings = root / "indra/newview/app_settings/settings.xml"
tree = ET.parse(settings).getroot()
keys = list(tree.find("map"))
values = {keys[i].text: keys[i + 1] for i in range(0, len(keys) - 1, 2)}
for name, expected in (
    ("OGLSidebarsEnabled", "1"),
    ("OGLLeftSidebarExpanded", "0"),
    ("OGLRightSidebarExpanded", "0"),
):
    assert name in values, f"Missing OGL sidebar setting: {name}"
    mapping = list(values[name])
    props = {mapping[i].text: mapping[i + 1].text for i in range(0, len(mapping) - 1, 2)}
    assert props.get("Type") == "Boolean" and props.get("Value") == expected
    assert props.get("Persist") == "1"

src = (root / "indra/newview/llviewerwindow.cpp").read_text(encoding="utf-8")
for anchor in (
    "void oglInitEdgeSidebars(LLView* root)",
    "void oglUpdateEdgeSidebars(LLView* root)",
    "void oglResetEdgeSidebars()",
    'oglInitEdgeSidebars(mRootView);',
    'oglUpdateEdgeSidebars(mRootView);',
    'oglResetEdgeSidebars();',
    'gSavedSettings.setBOOL(side.expanded_setting',
    'gSavedSettings.getBOOL("OGLSidebarsEnabled")',
    '"ogl_left_drawer"',
    '"ogl_right_drawer"',
    'LLFloaterReg::toggleInstance(floater_key)',
    '"inventory"', '"appearance"', '"people"', '"fs_nearby_chat"',
    '"world_map"', '"mini_map"', '"build"', '"preferences"',
):
    assert anchor in src, f"Missing sidebar contract: {anchor}"
print("OGL M2 collapsible inworld sidebars: static guard PASS")
