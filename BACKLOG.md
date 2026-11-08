# Backlog

Open items not tracked anywhere else (no GitHub issues yet).

- [ ] **Run a real Lua syntax check.** `main.lua` has never been through `luac` (the
      original dev box had no interpreter). Run `luac5.4 -p main.lua` once.
- [ ] **Add a Lua lint step to the Action** so an auto-added line that breaks syntax
      fails CI instead of landing on `main`. (`apt install lua5.4` + `luac5.4 -p`.)
- [ ] **Bind-test more protocols on hardware.** Only a subset (incl. SGF22) has been
      confirmed on the X20PRO AW; the rest are correct per firmware docs but untested.
- [ ] **Review Ares (108) and MoFly (109)** — added by the Action, still generic (no
      `maxChannels`/failsafe yet; no `Protocols_Details.md` section existed when added).
- [ ] **Review `-- [auto-added]` lines** whenever the Action adds one: set
      `maxChannels`, failsafe, and protocol-specific options from `Protocols_Details.md`.
- [ ] **Bump Action versions** (`actions/checkout`, `actions/setup-python`) when GitHub
      drops Node 20 — currently only a warning.
- [ ] *Optional:* switch the workflow from auto-commit to PR mode if review before
      landing on `main` is wanted (needs the repo setting "Allow GitHub Actions to
      create and approve pull requests").
- [ ] *Optional:* tests for `tools/sync_protocols.py` (parsers + `insert_alphabetically`);
      today it's only been checked by hand.
