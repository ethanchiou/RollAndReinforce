# TODO — Roll & Reinforce

> Items **not yet implemented**. When something ships, delete it from here and add it to `SPEC.md` → Recently Done.

---

## Week 1 — Foundation

- [x] Install Rojo (and Aftman if not already) — Aftman 0.3.0, Rojo 7.4.4, Wally 0.3.2 installed
- [x] Initialize git repo in this directory — initial scaffold committed on `main`
- [x] Draft initial item catalog — 10 items scaffolded in `src/shared/Items.luau` + `docs/item-database.md`; expand to 15-20 before week 8
- [ ] **Add `~/.aftman/bin` to your shell PATH.** Append to `~/.zshrc`: `export PATH="$HOME/.aftman/bin:$PATH"` then `source ~/.zshrc`. (Claude was blocked from editing zshrc.)
- [ ] **Migrate Aftman → Rokit before 2026-07-19** (Aftman upstream archived; Brew formula sunset date). `rokit.toml` has the same format as `aftman.toml`.
- [ ] Uncomment + install Wally deps: Knit, ProfileService, TestEZ — currently commented in `wally.toml`. Run `wally install` after.
- [ ] Lock game name (currently "Roll & Reinforce")
- [ ] Lock fortress aesthetic (lean: suburban house)
- [ ] Stand up a blank Roblox place; verify Rojo sync works
  - Run `rojo serve default.project.json` from terminal
  - In Roblox Studio, install the Rojo plugin (one-time)
  - Click Rojo plugin → Connect (default port 34872)
  - Press Play → verify `[RollAndReinforce] Server bootstrapping…` appears in Output panel

## Week 2 — Slot machine + roll math

- [x] `src/shared/RollMath.luau` — implement `rollItem(weights, modifiers)`, `rollModifier()` (signature done; round modifier not yet rolled)
- [x] `src/shared/Items.luau` — 10 items scaffolded (target 15-20 before week 8)
- [x] TestEZ tests for roll weighting distribution (spec file written; needs runner in Studio)
- [ ] `src/client/SlotMachineUI.luau` — 3-reel animation, result reveal
- [ ] `src/server/RollService.luau` — server-authoritative roll, returns to client
- [ ] Implement actual round-modifier rolling in `RollMath.rollItem` (TODO marker present)

## Week 3 — Carry + place mechanic

- [ ] `src/client/ItemCarry.luau` — first-person item attachment to view model
- [ ] `src/client/PlacementPreview.luau` — ghost preview at targeted spot
- [ ] `src/server/Placement.luau` — pathfinding validation + commit
- [ ] Build phase timer (starts on placement)
- [ ] Movement speed penalty while carrying

## Week 4 — Wave system + 3 zombie types

- [ ] `src/server/Waves.luau` — wave definitions, scaling formula
- [ ] Walker, Runner, Brute (basic AI: path to item + nearest player)
- [ ] Spawn points around fortress perimeter
- [ ] Round-end detection (wave cleared or timer out)
- [ ] First solo playtest

## Week 5 — Building system + shop UI

- [ ] Reinforcement objects: wall (3 tiers), spike, trip wire, barricade, turret slot
- [ ] `src/server/Building.luau` — placement validation for reinforcements
- [ ] `src/client/ShopUI.luau` — sell items, buy reinforcements, repair, reroll
- [ ] Coins + Scrap balances + transactions

## Week 6 — Remaining zombie types + wave scaling

- [ ] Climber (wall-bypass + audio + minimap ping)
- [ ] Spitter (ranged AI + acid projectile)
- [ ] Wave scaling formula tuned for solo + 2p
- [ ] Difficulty curve through round 10

## Week 7 — Co-op networking + 2-player playtest

- [ ] Player join/leave handling mid-match
- [ ] Shared fortress state sync
- [ ] Decide: shared coins or per-player (playtest both)
- [ ] Ping system for callouts + placement suggestions
- [ ] First 2-player playtest

## Week 8 — Full item catalog + retention logic + 4p playtest

- [ ] All 15-20 items implemented (effects, sell values, placement footprints)
- [ ] `retentionRounds` tracking per placed item
- [ ] "Item banked" celebration UI
- [ ] First 4-player playtest

## Week 9 — Persistence

- [ ] ProfileService integration
- [ ] Save: banked items, coins, meta-XP, cosmetics
- [ ] Cross-session continuity verified

## Week 10 — Tutorial, minimap, polish

- [ ] Tutorial round 1 (guided, placeholder zombies)
- [ ] Minimap with zombie pings
- [ ] Between-round scout camera
- [ ] Audio pass (climber cue critical)
- [ ] Closed friends-group playtest (unlisted)

## Week 11 — Balance + monetization

- [ ] Balance pass on rarity weights + retention rounds
- [ ] Wave scaling final tuning
- [ ] Gamepass integration: 2× coins, +2 slots, extra reinforcement
- [ ] Cosmetic pipeline (1 placeholder skin set)

## Week 12 — Soft launch

- [ ] Soft launch (public, undiscovered)
- [ ] KPI dashboard: session length, R5/R10 completion, gamepass conversion, D1/D7
- [ ] Iteration plan v2

---

## V2 / Post-MVP backlog

- [ ] **Balatro-style joker system** (see `SPEC.md` § Slot Machine V2) — biggest retention win
- [ ] Multiple maps
- [ ] Boss waves / mini-bosses
- [ ] Deep meta-progression tree (unlock new items, fortress perks)
- [ ] Burrower zombie
- [ ] Custom fortress saving/sharing
- [ ] Daily challenges / leaderboards
- [ ] PvP / raid mode

---

## Cross-cutting / always-on

- [ ] Keep `SPEC.md` Recently Done up to date as items ship
- [ ] TestEZ coverage for all shared modules (roll math, item db lookups, wave scaling formula)
- [ ] Rojo sync stable; no manual Studio edits checked into git
