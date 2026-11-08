#!/usr/bin/env python3
"""
Sync main.lua against the upstream DIY-Multiprotocol-TX-Module firmware.

`main.lua` is the hand-curated source of truth (friendly names, options, failsafe
flags, channel limits). This script does NOT regenerate it from scratch -- it only
*adds* protocols that exist in the upstream firmware but are missing from main.lua,
so the curation is never clobbered. New entries are inserted alphabetically and
tagged `-- [auto-added]` so a human can later refine options / channel limits.

Sources (upstream master branch):
  - Multiprotocol.h : authoritative protocol-number enum (PROTO_xxx = N)
  - Multi.txt       : radio display list "id,Name,sub0,sub1,..." (names + variants)

Usage:
  python tools/sync_protocols.py          # update main.lua in place
  python tools/sync_protocols.py --check   # report only, exit 1 if out of date
"""
import argparse
import os
import re
import sys
import urllib.request

RAW = "https://raw.githubusercontent.com/pascallanger/DIY-Multiprotocol-TX-Module/master/Multiprotocol"
MULTI_H = RAW + "/Multiprotocol.h"
MULTI_TXT = RAW + "/Multi.txt"

MAIN_LUA = os.path.join(os.path.dirname(__file__), os.pardir, "main.lua")

# Non-RC / special / debug protocols that are intentionally not offered for binding.
SKIP_NUMS = {
    0,    # PROTOLIST  - protocol list export, not a real protocol
    63,   # XN297DUMP  - debug NRF sniffer
    86,   # CONFIG     - module configuration (radio handles separately)
    88,   # WILLIFM    - external 27/35/40/41/72 MHz project, not RF-module based
    126,  # NANORF     - dev/test
    127,  # TEST       - dev/test
}

# Placeholder sub-protocol labels that occupy an index but aren't selectable modes.
PLACEHOLDER_SUBS = {"-", "--", "---", ""}

# Generic MULTI module options the firmware honors for every transmitting protocol.
GENERIC_OPTIONS = ("options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, "
                   "LOW_POWER_OPTION}")
# Receiver / scanner pseudo-protocols where those generic options don't apply.
NO_GENERIC_OPTIONS = {54, 55, 56, 59, 70}  # Scanner, Frsky_RX, AFHDS2A RX, Bayang RX, DSM_RX


def fetch(url):
    req = urllib.request.Request(url, headers={"User-Agent": "ethos-multi-lua-sync"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return r.read().decode("utf-8", "replace")


def parse_enum(text):
    """{number: IDENT} for every PROTO_xxx = N in Multiprotocol.h."""
    out = {}
    for m in re.finditer(r"PROTO_(\w+)\s*=\s*(\d+)", text):
        out[int(m.group(2))] = m.group(1)
    return out


def parse_multi_txt(text):
    """{number: (name, [subs])} from Multi.txt."""
    out = {}
    for line in text.splitlines():
        line = line.strip()
        m = re.match(r"^(\d+),(.+)$", line)
        if not m:
            continue
        num = int(m.group(1))
        fields = [f.strip() for f in m.group(2).split(",")]
        name = fields[0]
        subs = fields[1:]
        # drop trailing placeholder/empty sub slots
        while subs and subs[-1] in PLACEHOLDER_SUBS:
            subs.pop()
        out[num] = (name, subs)
    return out


def existing_numbers(lua):
    """{number: name} already registered in main.lua."""
    out = {}
    for m in re.finditer(r'registerMultimoduleProtocol\("([^"]+)",\s*(\d+)', lua):
        out[int(m.group(2))] = m.group(1)
    return out


def lua_str_list(items):
    return "{" + ", ".join('"%s"' % s for s in items) + "}"


def build_register_line(num, name, subs):
    parts = []
    meaningful = [s for s in subs if s not in PLACEHOLDER_SUBS]
    if len(meaningful) >= 2:
        parts.append("variants=%s" % lua_str_list(subs))
    if num not in NO_GENERIC_OPTIONS:
        parts.append(GENERIC_OPTIONS)
    table = (", {" + ", ".join(parts) + "}") if parts else ""
    return ('    system.registerMultimoduleProtocol("%s", %d%s) '
            "-- [auto-added] review options/channel limits\n" % (name, num, table))


def insert_alphabetically(lines, new_line, new_name):
    """Insert new_line into the init() body just before the first register call
    whose protocol name sorts after new_name (case-insensitive)."""
    key = new_name.lower()
    reg_re = re.compile(r'registerMultimoduleProtocol\("([^"]+)"')
    last_reg_idx = None
    for i, line in enumerate(lines):
        m = reg_re.search(line)
        if not m:
            continue
        last_reg_idx = i
        if m.group(1).lower() > key:
            lines.insert(i, new_line)
            return
    # all existing names sort before the new one -> after the last register line
    if last_reg_idx is not None:
        lines.insert(last_reg_idx + 1, new_line)
    else:
        lines.append(new_line)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true",
                    help="report only; exit 1 if main.lua is missing protocols")
    args = ap.parse_args()

    path = os.path.normpath(MAIN_LUA)
    with open(path, encoding="utf-8") as f:
        lua = f.read()

    enum = parse_enum(fetch(MULTI_H))
    txt = parse_multi_txt(fetch(MULTI_TXT))
    have = existing_numbers(lua)

    missing = sorted(n for n in enum
                     if n not in have and n not in SKIP_NUMS)
    removed = sorted(n for n in have if n not in enum)

    summary = []
    if removed:
        summary.append("Protocols in main.lua no longer in upstream (NOT removed, "
                        "review manually): " + ", ".join(
                            "%d %s" % (n, have[n]) for n in removed))

    if not missing:
        summary.append("main.lua is up to date with upstream (%d protocols, %d known "
                       "upstream)." % (len(have), len(enum)))
        report(summary)
        return 0

    added = []
    for num in missing:
        name, subs = txt.get(num, (None, []))
        if not name or name in PLACEHOLDER_SUBS or name.isdigit():  # bad upstream name -> use PROTO_ ident
            name = enum[num].title().replace("_", "")  # fallback from PROTO_ ident
        added.append("%d %s" % (num, name))

    summary.insert(0, "Missing upstream protocols: " + ", ".join(added))

    if args.check:
        report(summary)
        return 1

    lines = lua.splitlines(keepends=True)
    for num in missing:
        name, subs = txt.get(num, (None, []))
        if not name or name in PLACEHOLDER_SUBS or name.isdigit():  # bad upstream name -> use PROTO_ ident
            name = enum[num].title().replace("_", "")
        insert_alphabetically(lines, build_register_line(num, name, subs), name)

    with open(path, "w", encoding="utf-8", newline="") as f:
        f.writelines(lines)

    summary.insert(0, "Added %d protocol(s) to main.lua." % len(missing))
    report(summary)
    return 0


def report(summary):
    text = "\n".join(summary)
    print(text)
    step = os.environ.get("GITHUB_STEP_SUMMARY")
    if step:
        with open(step, "a", encoding="utf-8") as f:
            f.write(text + "\n")


if __name__ == "__main__":
    sys.exit(main())
