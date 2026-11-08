# CLAUDE.md

## Purpose
`main.lua` is the FrSky multi-module (MULTI / DIY-Multiprotocol-TX-Module) protocol
list for **ETHOS** radios. FrSky's stock list lags the module firmware, so this keeps
the protocol numbers, sub-protocol variants, options and channel limits current with
upstream: https://github.com/pascallanger/DIY-Multiprotocol-TX-Module

The radio reads `main.lua` to know which protocols/variants to show and which options
(Bind on channel, Disable telemetry, Low power, RF tune, failsafe, …) to expose per
protocol. See `README.md` for the user-facing install/usage and the list of changes
vs. FrSky's 1.6 list.

## Supported
- **Radios:** FrSky X20PRO AW (any ETHOS radio that takes a MULTI module should work;
  only the X20PRO AW has been tested).
- **Base:** FrSky's ETHOS 1.6 `lua/modules/multi/main.lua`, extended. Runs on current
  ETHOS.
- **Module:** needs a MULTI module running firmware new enough to have the protocol
  compiled in — the list only *exposes* a protocol, the firmware must support it.

## Repo layout
- `main.lua` — the protocol list (the deliverable). Hand-curated source of truth.
- `tools/sync_protocols.py` — compares `main.lua` to upstream and *appends* missing
  protocols (never rewrites existing lines). Functions: `fetch`, `parse_enum`,
  `parse_multi_txt`, `existing_numbers`, `build_register_line`, `insert_alphabetically`.
- `.github/workflows/sync-upstream.yml` — daily cron + manual trigger; runs the script
  and auto-commits new protocols to `main`.
- `README.md` — user docs. `BACKLOG.md` — open items.

## Testing

| Step | Command |
|---|---|
| Lua syntax check | `luac5.4 -p main.lua` (install: `sudo apt install lua5.4`) |
| Sync / up-to-date check | `python3 tools/sync_protocols.py --check` (exit 1 = missing protocols) |
| In the real radio | copy `main.lua` to the SD card (see Hardware), restart, bind a model |

There is no unit-test suite — the Python has no tests and the Lua only runs on the
radio/simulator. Syntax check + the sync `--check` are the only checks that run on a
plain dev box. Always run `luac5.4 -p` after editing `main.lua`.

## Release
No versioned releases/tags. "Release" = land it on `main`; users pull `main.lua`.
1. Edit `main.lua` (or let the daily Action append new protocols).
2. `luac5.4 -p main.lua` — must pass.
3. Commit and push to `main`.
4. Copy `main.lua` onto the radio SD card (Hardware) to use it.

## Current state
103 protocols. Up to date with upstream as of the last commit. All three generic
module options (Bind on channel / Disable telemetry / Low power) are on every
transmitting protocol; the RX/Scanner pseudo-protocols (54, 55, 56, 59, 70) are
excluded. Tested working on the X20PRO AW. The daily Action keeps it in sync.

## Open items
See `BACKLOG.md`.

## Gotchas
- **No Lua interpreter on the old Windows dev box** — `main.lua` was only validated by
  brace/structure checks there. On Debian, actually run `luac5.4 -p main.lua`.
- **Source conflicts:** upstream `Multi.txt` (names + variants) can lag
  `Multiprotocol.h` (authoritative numbers). The sync script trusts `.h` for which
  numbers exist and `Multi.txt` for names/variants. A few variant lists (AFHDS 2A,
  MouldKg, Traxxas) differ between the two docs — `main.lua` follows current firmware.
- **Auto-added protocols** land with generic options + a `-- [auto-added]` tag but no
  channel limits / protocol-specific options — review those lines after the Action runs.
- **Workflow auto-commits to `main`** (not a PR). GitHub can't trigger the instant
  upstream changes, so it's a daily poll. The Action shows a harmless Node 20→24
  deprecation warning.

## Hardware
Which steps need the radio or ETHOS Suite on the machine, and which run anywhere
(e.g. a headless Linux VM with no USB):

**Runs anywhere — no radio/USB:**
- Editing `main.lua`, `README.md`, the sync script.
- `luac5.4 -p main.lua` (Lua syntax).
- `python3 tools/sync_protocols.py [--check]`.
- git, and the GitHub Action (runs on GitHub's runners).

**Needs the radio, or ETHOS Suite installed on that machine:**
- **SD card copy:** put `main.lua` at `scripts/modules/multi/main.lua` on the radio's
  SD card (confirm the path against your ETHOS version's existing file). Needs the
  radio or its card mounted — so a USB-less VM can't do this step.
- **ETHOS Suite simulator:** FrSky's ETHOS Suite (Windows/macOS) can run the module
  lua without the radio, but it must be installed locally.
- **Live bind test:** the only real test — needs the radio, a MULTI module, and a model.
