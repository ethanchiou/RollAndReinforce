# TODO — Roll & Reinforce

> Items **not yet implemented**. When something ships, delete it from here and add it to `SPEC.md` § Recently Done. For build state, see `STATUS.md`.

---

## 🎯 Do these next (current blockers)

Ordered by what unblocks what. Top items are pure human-only steps.

1. [ ] **Save the Studio place** as `place.rbxlx` (anywhere outside the repo — it's gitignored). Your local workspace; only code is committed.
2. [ ] **Lock the 8 open design decisions** in `SPEC.md` § Open Decisions (Week 1). Top three to nail first: **name**, **aesthetic**, **who rolls**.
3. [ ] **Tag perimeter spawn parts in Studio** with `CollectionService` tag `ZombieSpawn` once the fortress block-out exists — required for `Placement.luau`'s reachability check to function.

After those: move into Week 2 work.

---

## 🧰 Manual setup needed (Studio asset import)

Blender authors `.blend` + `.fbx` under `Assets/`; Rojo only syncs `src/`, so meshes have to be imported into Studio once. Repeat per asset whenever a new `.fbx` lands or an existing one is rebuilt.

**Per-asset import procedure:**

1. Open Studio with `place.rbxlx` (your local working place file).
2. Drag the `.fbx` into the 3D viewport (or File → New From File…).
3. In the import dialog: **Scale: 1** (Blender m = stud), uncheck "Import textures" (materials are vertex-color), Collision Fidelity: **Default** for now.
4. Move the imported `MeshPart` into `ReplicatedStorage.Models.<Category>.<AssetName>` (create the folder hierarchy on first import). Categories: `Zombies`, `Reinforcements`, `Weapons`.
5. Set `Anchored = true` on reinforcement meshes. Weapons stay unanchored.
6. For irregular silhouettes (pineapple sledge, roof ramp, climber zombie) bump `CollisionFidelity = "PreciseConvexDecomposition"` after import.
7. Save the place (`Ctrl+S`). The mesh uploads to your experience's CDN; the `MeshId` persists for future sessions.
8. **Re-import workflow** (when an `.fbx` is rebuilt): right-click the existing `MeshPart` → Save to File (backup if you want), then drag the new `.fbx` over the same `MeshPart` in the Explorer to replace its mesh in place. The `MeshId` updates, the path stays the same so Luau references don't break.

**Assets pending first import** (uncheck as imported):

Zombies — `Assets/zombies/`:
- [ ] `zombie-base` (Walker)
- [ ] `zombie-runner`
- [ ] `zombie-brute`
- [ ] `zombie-climber`
- [ ] `zombie-spitter`

Reinforcements — `Assets/reinforcements/`:
- [ ] `reinf-door`
- [ ] `reinf-wall`
- [ ] `reinf-roof` (modular ramp section — multiple can be tiled for a full roof)
- [ ] `reinf-roof-plate` (armored ramp, same footprint as `reinf-roof`)
- [ ] `blockade-hall`
- [ ] `blockade-stair`

Weapons — `Assets/weapons/`:
- [ ] `weapon-baguette-bat`
- [ ] `weapon-pineapple-sledge`
- [ ] `weapon-carrot-darts`

`.rbxlx` is gitignored, so the imported `MeshPart`s only exist in your local Studio session + the Roblox CDN. Anyone cloning the repo re-imports from the `.fbx` source files.

---

## ⚠️ Operational debt to clear

- [ ] **Migrate Aftman → Rokit before 2026-07-19.** Aftman's upstream is archived. `rokit.toml` uses the same format as `aftman.toml`, so migration is trivial. Install Rokit (`cargo install rokit` or the official installer), copy `aftman.toml` → `rokit.toml`, `rokit install`.
- [ ] **Uncomment + install Wally deps** when first used: Knit, ProfileService, TestEZ. Currently commented in `wally.toml`. Run `wally install` after.

---

## Week 1 — Foundation

- [x] Install Aftman 0.3.0, Rojo 7.4.4, Wally 0.3.2
- [x] `git init` + initial scaffold commit on `main`
- [x] Scaffold initial item catalog — 10 items in `src/shared/Items.luau` + `docs/item-database.md`
- [x] Rojo serve verified working on `localhost:34872`
- [x] Studio connect + Play verified — Output panel shows server + client bootstrap lines
- [x] Blender MCP bridge probed live (`get_scene_info` returns; `execute_blender_code` ready)
- [ ] Items above in **Do these next** (place file, decisions, spawn tags)

## Week 2 — Slot machine + roll math

- [x] `src/shared/RollMath.luau` — `rollItem(weights, modifiers)` signature done (Balatro v2-ready)
- [x] `src/shared/Items.luau` — 10 items scaffolded (target 15-20 by week 8)
- [x] TestEZ specs for roll weighting distribution (need to be runnable from Studio — see Week 1 Wally deps)
- [ ] `src/client/SlotMachineUI.luau` — 3-reel animation, result reveal
- [ ] `src/server/RollService.luau` — server-auth roll, RemoteEvent replicates result to roller
- [ ] Implement round-modifier roll inside `RollMath.rollItem` (TODO marker in code)

## Week 3 — Carry + place mechanic

- [x] `src/server/Placement.luau` — pathfinding validation + commit (skeleton done; needs `ZombieSpawn`-tagged parts to actually validate)
- [ ] `src/client/ItemCarry.luau` — first-person item attachment to view model
- [ ] `src/client/PlacementPreview.luau` — ghost preview at targeted spot
- [ ] Build phase timer (starts on placement)
- [ ] Movement speed penalty while carrying

## Week 4 — Wave system + 3 zombie types

- [x] `src/server/Waves.luau` — hand-authored r1-3 + procedural r4+, sub-linear player-count scaling
- [ ] Walker, Runner, Brute zombie models + scripts (basic AI: path to item + nearest player)
- [ ] Spawn-point block-out around fortress perimeter (Studio work, then tag `ZombieSpawn`)
- [ ] Round-end detection (wave cleared or timer out)
- [ ] First solo playtest

## Week 5 — Building system + shop UI

- [ ] Reinforcement objects: wall (3 tiers), spike, trip wire, barricade, turret slot
- [ ] `src/server/Building.luau` — placement validation for reinforcements
- [ ] `src/client/ShopUI.luau` — sell items, buy reinforcements, repair, reroll
- [ ] Coins + Scrap balances + transactions

## Week 6 — Remaining zombie types + wave scaling

- [ ] Climber zombie (wall-bypass + distinct audio + minimap ping)
- [ ] Spitter zombie (ranged AI + acid projectile)
- [ ] Wave scaling tuned for solo + 2p (curves through round 10)

## Week 7 — Co-op networking + 2-player playtest

- [ ] Player join/leave mid-match handling
- [ ] Shared fortress state sync
- [ ] Decide via playtest: shared coins or per-player
- [ ] Ping system for callouts + placement suggestions
- [ ] First 2-player playtest

## Week 8 — Full item catalog + retention logic + 4p playtest

- [ ] Items expanded to 15-20 (full catalog in `docs/item-database.md` stretch list)
- [ ] `retentionRounds` tracking per placed item (skeleton in `Placement.tickRound`)
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
- [ ] Closed friends-group playtest (unlisted experience)

## Week 11 — Balance + monetization

- [ ] Balance pass on rarity weights + retention rounds
- [ ] Wave scaling final tuning
- [ ] Gamepass integration: 2× coins, +2 slots, extra reinforcement
- [ ] Cosmetic pipeline (1 placeholder skin set)

## Week 12 — Soft launch

- [ ] Soft launch (public, undiscovered)
- [ ] KPI dashboard: session length, R5/R10 completion, gamepass conversion, D1/D7 retention
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

## Art pipeline (active — pulled forward from week 5+)

The Roll & Reinforce visual identity lives in ~5-10 hero items + the slot machine itself + the zombie roster. Everything else is pack assets.

Pulled forward because the Blender MCP bridge is live now and the procedural pipeline is the fastest way to lock the visual direction before gameplay code accumulates around placeholder models. See `SPEC.md` § Zombie Roster § Visual direction for the style spec.

- [x] **Base zombie (Walker)** — shipped 2026-05-19. `Assets/zombies/zombie-base.blend` + `.fbx`. 352 verts / 528 tris. Open mouth + bandages + bloodstain + skin/cloth noise mottling.
- [x] **Runner** — shipped 2026-05-19. `Assets/zombies/zombie-runner.{blend,fbx}`. 272 v / 408 t. Forward-leaning sprinter, red eyes, sprint arm pose.
- [x] **Brute** — shipped 2026-05-19. `Assets/zombies/zombie-brute.{blend,fbx}`. 400 v / 600 t. Wide, no-neck, massive arms, chest plate, knuckle spikes, asymmetric oversized eye.
- [x] **Climber** — shipped 2026-05-19. `Assets/zombies/zombie-climber.{blend,fbx}`. 344 v / 516 t. Tall mantis, pale skin, hand+toe claws, purple eyes.
- [x] **Spitter** — shipped 2026-05-19. `Assets/zombies/zombie-spitter.{blend,fbx}`. 304 v / 456 t. Back-tilted, glowing acid sac, drooling mouth, atrophied arms.
- [x] **Reinforcement pack v1** — shipped 2026-05-19. Door (796 t), wall (984 t), roof (2004 t), roof-plate armor (644 t), hall blockade (2400 t), stair blockade (1124 t) under `Assets/reinforcements/`. All wood-tier first pass; metal/reinforced tiers TBD.
- [x] **Weapon trio v1** — shipped 2026-05-19. Baguette bat (1420 t), pineapple sledge (2368 t), carrot throwing darts (2368 t) under `Assets/weapons/`. Food-themed comedic melee + thrown set.
- [ ] Hero items in Blender — Crown of Ash, Gemstone Idol, Ancient Relic, slot machine cabinet.
- [ ] Optionally: low-poly fortress pack from Roblox Creator Store ($50-200) for the shell. Hero items still authored bespoke.
- [ ] Roblox MeshPart limits to respect: ≤21,000 tris, ≤1024×1024 texture per surface. Target for zombies: ≤1500 tris, 512² albedo.
- [ ] Author `docs/blender-pipeline.md` when the first zombie ships — repeatable export checklist.

---

## Cross-cutting / always-on

- [ ] Keep `SPEC.md` § Recently Done current as items ship
- [ ] Keep `STATUS.md` current when material state changes (tooling, services, blockers)
- [ ] TestEZ coverage for all shared modules (roll math, item db lookups, wave scaling formula)
- [ ] Rojo sync stable; no manual Studio code edits checked into git
