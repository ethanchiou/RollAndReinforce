# STATUS — Roll & Reinforce

> Point-in-time snapshot of the build. Update when material state changes (tooling installed, services running, blockers resolved). For *what we're building* see `SPEC.md`; for *what's left* see `TODO.md`.

**Last updated:** 2026-05-12
**Build phase:** Pre-implementation — scaffold complete, awaiting first Studio sync.
**Working title:** Roll & Reinforce (not locked)

---

## Elevator pitch

Co-op (2-4) first-person zombie-fortress defense on Roblox. Roll a slot machine → carry the rolled item into the fortress → place it → defend through waves. Items "bank" after their rarity-tier survival count; unbanked items lost if the fortress falls.

---

## What's running right now

| Service | Status | Detail |
|---|---|---|
| **Rojo server** | 🟢 Listening | `localhost:34872`, PID 58357. Background task in active Claude session. |

To stop Rojo: `kill 58357` (or close the Claude session that owns the background task).
To verify: `lsof -i :34872 -P` should show the rojo process.

---

## Tooling installed

| Tool | Version | Path | Notes |
|---|---|---|---|
| Aftman | 0.3.0 | `/opt/homebrew/bin/aftman` | ⚠️ Brew formula deprecated. Migrate to **Rokit** before 2026-07-19. |
| Rojo | 7.4.4 | `~/.aftman/bin/rojo` | Pinned in `aftman.toml`. |
| Wally | 0.3.2 | `~/.aftman/bin/wally` | Pinned in `aftman.toml`. No deps installed yet — `wally.toml` entries commented. |
| Git | 2.48.1 | `/usr/bin/git` | System-default. |
| Roblox Studio | (Mac app) | `/Applications/RobloxStudio.app` | Plugin install + Connect still required (manual). |
| Blender | 5.1.1 | `/Applications/Blender.app` | CLI accessible via `--background --python`. No MCP wired into this session. |

**Shell PATH:** `~/.aftman/bin` is **not** in `~/.zshrc`. Tools work from inside the project (aftman shim resolution), but for global use append:
```bash
export PATH="$HOME/.aftman/bin:$PATH"
```

---

## Git state

```
Branch:    main
Commits:   2 on main
   5f2b5d0  Mark week 1 install steps complete; document PATH + Rokit migration
   974faab  Initial scaffold: Roll & Reinforce co-op zombie-fortress Roblox MVP
Remote:    (none yet — local-only)
Worktree:  clean
```

No remote. When ready: `gh repo create RollAndReinforce --private --source=. --push`.

---

## Files on disk

```
RollAndReinforce/
├── .gitignore
├── README.md
├── SPEC.md                     (design source of truth)
├── TODO.md                     (implementation checklist)
├── STATUS.md                   (this file)
├── CLAUDE.md                   (agent guidance)
├── aftman.toml                 (Rojo + Wally version pins)
├── wally.toml                  (Knit/ProfileService/TestEZ commented)
├── default.project.json        (Rojo project config)
├── Packages/                   (placeholder — empty; wally install will populate)
├── assets/                     (empty — for models, sounds, UI)
├── docs/
│   ├── design-doc.md           (rationale + alternatives considered)
│   └── item-database.md        (catalog + future items)
└── src/
    ├── client/init.client.luau (bootstrap)
    ├── server/init.server.luau (bootstrap with smoke roll)
    ├── server/Placement.luau   (server-auth placement + pathfinding check)
    ├── server/Waves.luau       (hand-authored r1-3 + procedural r4+, sub-linear player scaling)
    ├── shared/Items.luau       (10-item catalog across 5 rarities)
    ├── shared/RollMath.luau    (Balatro v2-ready: rollItem(weights, modifiers))
    ├── shared/Types.luau       (strict-typed shared types)
    └── tests/RollMath.spec.luau (TestEZ specs: distribution within 5% over 10k rolls)
```

**Line count:** ~1325 lines across 14 source + 6 doc files.

---

## What works end-to-end

- ✅ Rojo project loads (verified — `rojo serve` started without errors after Packages placeholder added).
- ✅ Server bootstrap prints item count + smoke roll on Play (verified in module wiring; needs Studio Play to confirm).
- ✅ Blender headless Python automation (verified — created 12-vert mesh from `bpy` script in 2026-05-12 smoke test).

## What's NOT wired yet

- ❌ No Wally deps installed (Knit, ProfileService, TestEZ are commented in `wally.toml`).
- ❌ No remote events / RemoteFunctions defined.
- ❌ No actual gameplay: no slot machine UI, no carry/place mechanic, no zombies, no shop.
- ❌ No persistence (ProfileService not wired).
- ❌ No Studio place file synced — Rojo is serving but nothing has connected to it yet.
- ❌ No fortress geometry, no spawn points (`ZombieSpawn` CollectionService tag has no instances).

---

## Open decisions (block week 2 polish, not week 1 scaffolding)

From `SPEC.md` § Open Decisions:

1. Final name (working: Roll & Reinforce)
2. Aesthetic / setting (lean: suburban house)
3. Per-player rolls vs. one designated roller
4. Reroll cost (lean: 1 free + scrap-cost after)
5. Skip mechanic (lean: yes, forfeit coin bonus)
6. Item slot cap per fortress (lean: 4-6)
7. Placement permanence across rounds (lean: stays placed until banked or destroyed)
8. Coins shared or per-player (lean: per-player coins, shared scrap)

---

## Immediate next actions (for the human)

1. **Add `~/.aftman/bin` to `~/.zshrc` PATH** — see Tooling Installed.
2. **Open Roblox Studio**, install the Rojo plugin (one-time), click Connect → port 34872.
3. **Press Play in Studio**, watch Output for `[RollAndReinforce] Server bootstrapping…` + smoke roll line.
4. **Save the Studio place as `place.rbxlx`** somewhere outside the repo (it's gitignored). This is your local workspace; commit code only via files.
5. **Lock the 8 open decisions** — capture answers in `SPEC.md` § Open Decisions.

After that → week 2 begins (slot machine UI + RollService remote pipeline + full item catalog).

---

## Known issues / risks

| Issue | Severity | Mitigation |
|---|---|---|
| Aftman deprecated, brew formula sunsets 2026-07-19 | Medium | Migrate to Rokit before deadline. Config format is compatible. |
| `Packages/` is empty but referenced in `default.project.json` | Low | Placeholder created. Real contents arrive when first Wally dep is uncommented + `wally install` runs. |
| `~/.aftman/bin` not on PATH globally | Low | One-line zshrc addition documented. |
| Background Rojo serve dies with the Claude session | Low | User can restart with `cd <project> && rojo serve default.project.json` anytime. |
| Roblox loot-box rules apply to slot machine | Medium | Documented in SPEC § Risks. Rolls free, odds visible, no Robux-cost rerolls — confirmed in design. |
