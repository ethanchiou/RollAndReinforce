# SPEC — Roll & Reinforce

> Single source of truth for **what we're building**. When something ships, move it from `TODO.md` → Recently Done below.

---

## Recently Done

- **2026-05-19** — First art asset: **base zombie (Walker)** shipped via procedural `bpy` script through the Blender MCP bridge. Output: `Assets/zombies/zombie-base.blend` + `zombie-base.fbx` (352 verts / 528 tris, ~5-stud height, Roblox-friendly axes). Style matches the new SPEC § Visual direction note — blocky-cartoony, asymmetric glowing pinprick eyes (bright left / dim right), open jagged-tooth mouth, layered bandages with bloodstain on the head wrap, torn shirt with rot peek-through, procedural noise mottling on skin + cloth for "more textures" without baking image maps, subtle forward hunch. The other four zombie types will be silhouette-edits off this base.
- **2026-05-19** — End-to-end Studio playtest verified. Rojo connected, Play loads the synced tree, Output panel shows the server bootstrap + smoke-roll lines and the client bootstrap lines. Nighttime lighting renders per `default.project.json` (`ClockTime: 19`, dim ambient) — confirms `Lighting` props sync correctly.
- **2026-05-19** — Blender MCP bridge probed live (Claude → addon on `:9876`). `get_scene_info` returns; `execute_blender_code` available. Hyper3D and Hunyuan3D AI-gen paths are currently disabled in the addon — first asset will be procedural `bpy`.
- **2026-05-19** — `.gitignore` extended with `*.rbxl.lock` / `*.rbxlx.lock` so Studio session locks stop leaking into `git status`. Commit `2972ae5` on `main`.
- **2026-05-18** — Infrastructure-clean pass on the scaffold. `selene.toml` + `testez.yml` (Roblox+TestEZ std), `stylua.toml` (tabs / 100-col / LF / double-quotes), `.gitattributes` (force LF repo-wide). `Packages/.gitkeep` so `rojo build` works on a fresh clone. Removed unused `Workspace` import in `Placement.luau`. Source reformatted under the new StyLua config. `selene src` and `stylua --check src` both 0/0 clean; `rojo build` produces a valid `.rbxl`.
- **2026-05-18** — `STATUS.md` and `TODO.md` refreshed for Windows host; stale macOS paths and dead background-process references removed.
- Project scaffolded (README, SPEC, TODO, CLAUDE, Rojo project file, skeleton Luau modules, docs/item-database.md).

---

## TL;DR

Co-op (2-4) **first-person** zombie-fortress defense on **Roblox**. Each round:

1. Roll a slot machine → an item appears in your hand (rarity dictates required survival rounds).
2. Walk the item into the fortress and place it. Placement triggers the build phase timer.
3. Reinforce. Survive the wave. Loot. Shop. Repeat.

Items "bank" after their rarity-tier survival requirement; if the fortress falls before then, unbanked items are forfeit. Banked items + meta-progression persist across runs.

---

## Engine: Roblox (Luau)

- Built-in audience for zombie / TD / gacha-roll loops (Tower Defense Simulator, Doors).
- Co-op networking is essentially free.
- Distribution + monetization handled by the platform.
- Tradeoff: 30%+ revenue cut, must comply with Roblox loot-box/gambling rules (no Robux-cost rerolls; rarity odds visible; rolls always free in-game-currency or free-per-round).

Tooling:
- **Rojo** — filesystem ↔ Studio sync for git versioning.
- **ProfileService** — persistent player data.
- **Knit** (or similar) — modular client/server services + remote handling.
- **TestEZ** — unit tests on roll math, economy, wave scaling.

---

## Core Game Loop

```
Lobby/safe room
  → Slot machine spins
  → Item materializes in roller's hand
  → Player walks into fortress and places item (1st-person carry + place)
  → BUILD PHASE timer starts (60-90s)
  → All players reinforce (walls, spikes, turret slots, traps)
  → WAVE PHASE begins
  → Zombies spawn at perimeter, path toward placed item + players
  → Survive → coins + scrap reward
  → Shop opens (sell/buy/repair/reroll)
  → Next round
  → Items bank after their rarity-tier rounds elapsed
  → Fortress falls → unbanked items lost, run ends, meta-XP awarded
```

---

## Game Design Pillars

1. **The roll matters.** Every roll changes the round's strategy.
2. **Placement is the player skill.** Where you put the item shapes kill zones, decoys, chokepoints. Re-placement is costly or impossible mid-round.
3. **Risk vs. bank.** Legendaries take 8-10 rounds to bank. Commit, or sell for coins and roll again?
4. **Co-op cohesion.** Solo-viable; co-op-thriving. Roles emerge naturally: builder / shooter / runner.
5. **First-person stakes.** Adrenaline at eye level. Minimap and a between-rounds top-down camera provide overview without breaking immersion.

---

## Rarity → Retention Schedule

| Rarity | Required survival rounds | Roll weight (MVP) |
|---|---|---|
| Common | 1 | 50% |
| Uncommon | 2 | 28% |
| Rare | 3 | 14% |
| Epic | 5 | 6% |
| Legendary | 8-10 | 2% |

Rates and round counts are subject to balance pass at week 11. Visible to the player at all times.

---

## Currencies

- **Coins** — shop currency. Earned by surviving rounds. Spent on: reinforcement upgrades, repairs, item resale (in reverse, you sell items for coins).
- **Scrap** — reinforcement currency. Earned from zombie kills + crates. Spent on: walls, spikes, traps, turret ammo, reroll-spins beyond the 1 free per round.

**Two currencies only.** Resisting the urge to add wood/metal/glass/etc. — it's confusing and adds nothing.

---

## Zombie Roster (MVP: 5-6 types)

| Type | Role | Behavior |
|---|---|---|
| Walker | Baseline horde filler | Slow, single-target melee, low HP. |
| Runner | Pressure / chaos | Fast, low HP, ignores some traps. |
| Brute | Tank | Slow, very high HP, smashes walls hard. |
| Climber | Wall-bypass | Climbs over single-tier walls — forces stacked defenses. Distinct audio + minimap ping. |
| Spitter | Ranged threat | Stops at distance, ranged acid. Targets the item if exposed. |
| (Stretch) Burrower | Late-round wildcard | Tunnels under perimeter, surfaces inside. Cut if scope-tight. |

### Visual direction (zombies)

**Cartoonish but mildly scary, Roblox-fit.** Not horror-realistic, not pure-cute. The reference axis is *Plants vs Zombies + Hollow Knight*, not *Left 4 Dead*. Specifically:

- **Silhouette first.** Each type must read at first-person distance from its silhouette alone — Walker hunched, Runner forward-leaning, Brute wide, Climber tall + clawed, Spitter back-tilted with a swollen sac. Silhouette legibility is the climber/spitter mitigation in `SPEC.md` § Risks.
- **Blocky proportions.** Slight nod to classic Roblox character build — oversized head, simple cubic torso, stylized limbs. Keeps faces below ~2k tris and reads at distance.
- **Pale-green skin, deep-shadow eye sockets, glowing pinprick eyes.** The eyes carry most of the menace; the rest of the face can be plain.
- **Tattered, low-saturation clothing.** Greys, browns, dust. Color belongs on items and reinforcements, not zombies — zombies are background, the placed item is the foreground.
- **No gore.** Avoid blood splatter or exposed-flesh textures — keeps the experience age-broad on Roblox and dodges moderation friction.
- **Low-poly.** Target ≤1500 tris per zombie body (well under Roblox's 21k MeshPart cap), single 512×512 albedo texture per type. Lets us spawn 30+ on screen without netcode strain.

Base zombie (Walker) is the first asset. The other four types are silhouette-edits of the same base mesh where possible.

---

## Slot Machine — Roll System

### V1 (MVP)

- Single 3-reel UI.
- Pure rolls: each round, one player rolls (or all roll, TBD week 1).
- Outcome = **one item** (selected by rarity weights) + **one optional round modifier** (e.g. "+25% coins this round", "1 free spike trap", "spitters deal -50% dmg this round").
- 1 free reroll per round. Additional rerolls cost scrap.

### V2 — Balatro-style synergy (POST-LAUNCH, but architect for it now)

**This is the long-term retention hook. Design v1 so v2 bolts on without rewriting the roll pipeline.**

- Persistent **joker slots** that modify all future rolls within a run:
  - "+10% legendary odds"
  - "Spitters drop 2× coins"
  - "First wall placed each round is free"
  - "Each Common item banked → +1% odds of next-tier roll"
- Shop sells jokers. Pick 3-5 per run, slots are limited.
- Combo discovery — players hunt for stacks that break the economy.
- Deck-building feel: each run is a different deck of modifiers.

**Implementation note:** the roll pipeline must take a list of modifiers as input from day 1 (even if MVP only ever passes an empty list). Don't hardcode raw rarity weights in the roll function — pass them as a parameter so jokers can mutate them.

---

## Item Catalog (initial — see `docs/item-database.md`)

15-20 items across the 5 rarity tiers. Each item has:
- `id` (string)
- `name`
- `rarity`
- `retentionRounds`
- `placementCategory` (small / medium / large — affects placement footprint)
- `roundModifier?` (optional passive effect while item is placed, e.g. "+1 scrap per kill")
- `sellValue` (coins if sold via shop)

---

## Building System: Hybrid

- **Exterior shell:** fixed. Pre-built fortress walls, gates, windows. Cannot be removed or moved.
- **Interior:** free-form placement of reinforcement objects within a defined footprint. Snapping to a 1-stud grid for sanity (not strict slots, but not pixel-precise either).
- **Reinforcement objects (MVP):**
  - Wall (3 tiers: wood → metal → reinforced)
  - Spike strip (single-target damage, breaks after N hits)
  - Trip wire (slows zombies)
  - Barricade (window-cover, blocks line of sight)
  - Turret slot (player-mounted, scrap-cost ammo)

**Server validation:** placement is rejected if pathfinding cannot reach the placed item from any spawn point. This is the anti-cheese check.

---

## Item Placement Mechanic

The signature design of this game.

1. After the roll, the item is materialized **in the rolling player's hand** (first-person, attached to view model).
2. Player walks around the fortress with the item visible.
3. While carrying:
   - Player has reduced movement speed (~80%).
   - Cannot use weapons.
   - Other players can ping suggested locations.
4. Player presses [Place] → item is placed at current targeted spot.
5. **Placement starts the build timer** — strategic pressure to commit, not dither.
6. Placement is permanent for that round. Repositioning between rounds: TBD (lean: stay placed unless banked or sold).
7. Server validates path-reachability before confirming placement.

---

## Win / Loss Conditions

- **Win a round:** survive the wave timer or kill the wave's quota.
- **Bank an item:** survive its required `retentionRounds` after placement, fortress still standing.
- **Lose a run:** fortress is destroyed (defined by fortress HP reaching 0, or the placed item being destroyed if it's the round's objective).
- **End of run rewards:** meta-XP based on rounds survived + items banked. Banked items persist across runs.

No fixed "end" — infinite-mode after round 15. Soft difficulty cap that escalates indefinitely.

---

## Co-op (2-4 players)

- Shared fortress, shared shop access, individual inventories.
- Shared economy: coins and scrap are pooled OR per-player (decide week 7 based on playtest).
- Wave intensity scales with player count, plus a soft modifier (not pure linear) so 4-player isn't 4× harder than solo — it's ~2.5×.
- Reviving downed teammates: yes, with a scrap cost.

---

## Monetization (F2P)

| Pass | Effect | Notes |
|---|---|---|
| 2× Coin Multiplier | Doubles coin earnings | Standard, safe |
| +2 Inventory Slots | More items carried between runs | QoL |
| Extra Reinforcement Slot / Round | Place 1 more reinforcement per round | Modest power |
| Cosmetic Skins | Weapons, fortress themes, slot UI | Highest LTV |

**Do NOT ship:** pay-for-extra-rolls. Roblox is tightening loot-box rules; pay-to-roll-more is exactly the line. If you want a paid roll-side perk, do "+1 free shop reroll per round" — that's shop-side, much safer.

**Rule:** gamepasses accelerate, never gate. F2P must be able to win every round and bank every rarity.

---

## Risks & Mitigations

| Risk | Mitigation |
|---|---|
| Roblox loot-box rules | Rolls free in-game. No Robux-cost rerolls. Rarity odds visible. |
| Placement abuse (unreachable spots) | Server-side pathfinding validation pre-placement. |
| First-person fortress legibility | Minimap. Between-round scout camera. Ping system. |
| Co-op netcode load (4p + many zombies + free placement) | Server-authoritative zombies + damage. Client-predict movement only. Cap placements per player. |
| Wave scaling (solo vs 4p both feel tight) | Sub-linear count scaling. Playtest at all player counts every milestone. |
| Climber zombie clarity in 1st-person | Distinct audio cue + minimap ping. |
| Players don't intuit the carry-place flow | Tutorial round 1 with safe placeholder zombies. |

---

## Open Decisions (Week 1)

These need locking before deep implementation:

1. **Final name.** Working: Roll & Reinforce. Alts: Vault Night, Hoard Defense, The Loot Watch.
2. **Aesthetic / setting.** Lean: suburban house (relatable, classic, fits 1st-person zombie tropes). Alts: bunker, mall, manor, vault.
3. **Who rolls?** Per-player rolls, or one designated roller per round? (Lean: each player gets one roll per round; placement timer starts when any player places.)
4. **Reroll cost.** Lean: 1 free reroll per round; additional cost scrap.
5. **Skip mechanic.** Lean: yes — you can skip your roll to leave an item slot open; you forfeit the round's coin bonus.
6. **Item slot cap per fortress.** Lean: 4-6 active items.
7. **Placement permanence.** Lean: placed items stay placed across rounds until banked or destroyed.
8. **Economy shared or per-player.** Lean: per-player coins, shared scrap (encourages cooperation without enabling freeloading).

Capture answers inline in this doc when decided.

---

## Verification / Playtest Plan

- Weekly solo playtest from week 2.
- 2-player co-op week 4.
- 4-player week 8.
- Closed friends-group playtest week 10 (unlisted experience).
- Soft launch week 12.

**KPIs:**
- Avg session length (target 25+ min)
- Round 5 completion rate (target 60%)
- Round 10 completion rate (target 25%)
- Gamepass conversion (target 3-5% WAU)
- D1 / D7 retention (target 35% / 12%)

---

## References

- Approved plan: `~/.claude/plans/you-are-expert-game-kind-hinton.md`
- Item catalog: `docs/item-database.md`
- Implementation checklist: `TODO.md`
