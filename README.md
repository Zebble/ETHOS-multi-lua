# ETHOS multi-module protocol list

An up-to-date `main.lua` for the **FrSky multi-module (MULTI / DIY-Multiprotocol-TX-Module)**
on ETHOS radios (e.g. FrSky X20PRO AW).

FrSky's stock list ([ETHOS-Feedback-Community](https://github.com/FrSkyRC/ETHOS-Feedback-Community/tree/1.6/lua/modules/multi))
lags the firmware, so newer protocols are missing. This `main.lua` adds them and keeps
the sub-protocol (variant) lists, options, failsafe flags and channel limits current with
the upstream firmware:

- [pascallanger/DIY-Multiprotocol-TX-Module](https://github.com/pascallanger/DIY-Multiprotocol-TX-Module)

## Install

Copy [`main.lua`](main.lua) onto the radio's SD card, replacing the existing file in the
`multi` module folder (the same place FrSky ships it — under `scripts/modules/multi/`),
then restart the radio. Confirm the path matches your ETHOS version's existing install.

> The list only *exposes* protocols in ETHOS — a protocol still has to be **compiled into
> your module's MULTI firmware** to actually bind. If a protocol won't bind, flash the
> latest MULTI firmware.

## What's different from FrSky's 1.6 list

Changes are tagged inline in `main.lua`:

- `-- [NEW]` — protocol added (e.g. FrSky R9, SGF22, Scorpio, BlueFly, UDIRC, WPL, …)
- `-- [UPD]` — variant/option list brought up to date (e.g. AFHDS 2A gyro modes, DSM
  `DSMR`/`DSM2-SFC`, RadioLink `RC4G`, XK `Cars`, …)

## Staying in sync with upstream automatically

[`tools/sync_protocols.py`](tools/sync_protocols.py) compares `main.lua` against the
upstream firmware's protocol enum (`Multiprotocol.h`) and display list (`Multi.txt`) and
**adds any protocols that are missing**. `main.lua` stays the hand-curated source of truth
— the script only *appends* new entries (tagged `-- [auto-added]`), so curated names,
options and failsafe flags are never overwritten.

```bash
python tools/sync_protocols.py          # add any missing protocols to main.lua
python tools/sync_protocols.py --check  # report only; exit 1 if out of date
```

The [`sync-upstream`](.github/workflows/sync-upstream.yml) GitHub Action runs the script
**daily** and commits any newly-added protocols. (GitHub can't trigger a build the instant
an upstream repo changes — you can only watch a repo you don't own on a schedule — so this
polls once a day. Use the **Run workflow** button on the Actions tab to sync on demand.)

When the bot adds a protocol it's a best-effort entry (name + variants from upstream).
Review the `-- [auto-added]` line afterwards to add any options, failsafe flag or
`maxChannels` the new protocol needs.

## Sources

- Protocol numbers: `Multiprotocol/Multiprotocol.h` (upstream `PROTO_xxx` enum)
- Names & sub-protocols: `Multiprotocol/Multi.txt`
- Per-protocol details (channels, telemetry, failsafe): `Protocols_Details.md`
