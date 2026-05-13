# Design Doc — Roll & Reinforce

> The long-form companion to `SPEC.md`. SPEC is "what we're building right now"; this doc is "why we're building it this way and what we considered."

## Origin

Brainstormed 2026-05-12 while working in the Hatchware marketing-site workspace. Promoted into its own project after a plan-mode session settled on Roblox + co-op (2-4) + first-person + 2-3 month polished MVP.

Approved plan: `~/.claude/plans/you-are-expert-game-kind-hinton.md`.

## The pitch in one paragraph

A co-op fortress-defense game on Roblox where each round starts with a slot-machine roll that gives you a valuable item to *physically* protect. You walk the item into the fortress, place it somewhere strategic, and that placement decision (kill zones, decoys, chokepoints) shapes the entire round. Rarer rolls demand more rounds of defense to "bank" — Commons after one round, Legendaries after eight to ten. Survive enough rounds and items become permanent; lose the fortress and unbanked items are gone. The slot evolves into a Balatro-style synergy system post-launch.

## Why this concept works

Most tower defense games abstract "the thing being defended" — the base, the crystal, the king. The novelty here is twofold:

1. **The protected item is variable.** Different rolls = different round strategies. A Crown of Ash in slot 4 is a totally different game than a Tarnished Coin in slot 4.
2. **You place it yourself.** Placement *is* the player skill. Where you put it determines pathing, kill zones, and what reinforcements matter.

Combine that with a retention-rounds mechanic and you have a "press your luck" loop that nests inside the wave defense — keep rolling for legendaries (committing to long defenses) or bank commons fast and hoard coins.

## Why Roblox

Considered:

- **Roblox** — built-in audience for exactly this genre (Tower Defense Simulator, Doors, Build A Boat). Free distribution. Free networking + monetization plumbing. Fast iteration in Luau. Trade: 30%+ revenue share, must navigate loot-box rules.
- **Unity** — full control, Steam/mobile/console reach, better visuals. Trade: build the audience from zero, longer dev cycles, write everything from scratch.
- **Godot** — fully open source, growing community. Trade: smallest audience, fewer ready-made systems for co-op.

Picked Roblox because the target audience for "zombie defense + gacha rolls + co-op" lives there, and a 2-3 month MVP cannot afford to build matchmaking + accounts + monetization from scratch.

## Why first-person

Considered top-down, third-person, first-person.

- **Top-down** — easiest, clearest, most legible. Rejected because it makes the fortress feel like a chess board, not a place. Defeats the "you placed this item and now you're sweating about it" feeling.
- **Third-person** — middle ground. Probably what we'd pick for Unity. On Roblox, the camera defaults and character control are great for first-person but middling for third.
- **First-person** — most immersive, most adrenaline. The cost is fortress legibility (mitigated with minimap + scout camera). Co-op first-person on Roblox has good examples (Phantom Forces, etc.) so the platform support is there.

Picked first-person for emotional payoff. Climber zombies climbing over your wall is much scarier at eye level.

## Why hybrid building (fixed shell + free interior)

- **Free-form anywhere** (Rust/Minecraft style) is too much scope and creates legibility problems for waves.
- **Pre-set slots** (Plants vs Zombies style) is achievable but loses the "build *your* fortress" feel.
- **Hybrid** — the shell handles perimeter + netcode + AI pathing predictably; the interior gives players creative expression. Best of both.

## Why two currencies

Considered: just coins, coins + scrap, coins + wood + metal, coins + wood + metal + ammo.

Picked coins + scrap. One spends on items/shop, one spends on reinforcements. Anything more is bookkeeping without depth.

## Roll mechanic — MVP vs V2

**MVP (v1):** pure rolls. 3-reel slot. Outcome = item + optional round modifier. Simple, balanced, shippable.

**V2:** Balatro-style. Persistent joker slots that mutate rarity weights and round modifiers within a run. Combos and synergies. Deck-building feel.

**Critical architectural decision:** the roll pipeline takes a list of modifiers as a parameter from day 1, even when MVP always passes an empty list. This means v2 jokers bolt on without rewriting roll math. See `src/shared/RollMath.luau` for the signature — `rollItem(weights, modifiers)` is the contract.

The Balatro mechanic is what would turn this from a 5-hour game into a 500-hour game. Don't ship it in MVP, but don't paint yourself into a corner where it requires a rewrite.

## Monetization

F2P with convenience-pass gamepasses (2× coins, +2 inventory slots, extra reinforcement per round, cosmetics).

**One non-obvious rule:** do not ship "pay for extra rolls." Roblox is tightening loot-box rules and pay-to-roll-more is exactly the line. The original convenience-pass concept included "extra rolls"; we deliberately swapped it for "+1 free shop reroll per round" — that's shop-side, much safer.

## Co-op design

- Solo-viable, co-op-thriving.
- Wave intensity scales sub-linearly with player count (4p ≈ 2.5× solo, not 4×). See `Waves.luau` for the multiplier table.
- Roles emerge organically: builder / shooter / runner. Don't enforce roles.
- Per-player coins, shared scrap (leaning) — encourages cooperation without enabling freeloading.

## What we explicitly aren't building (MVP)

- Multiple maps. One polished map > three half-baked ones.
- Boss waves. Tempting but a whole separate balance problem.
- Deep meta-progression tree. Banked items + cosmetics persist; that's it for MVP.
- PvP / raid mode. Different game.
- Custom fortress saving/sharing. Different game.
- Balatro synergies. Architected for, not shipped in MVP. **This is the v2 hook.**

## Open questions for week 1 (capture answers in SPEC.md)

1. Final name (working: Roll & Reinforce)
2. Aesthetic (lean: suburban house)
3. Who rolls — every player, or one designated?
4. Reroll cost — free once, then scrap?
5. Skip mechanic — yes, but forfeit coin bonus?
6. Item slot cap per fortress — 4-6?
7. Placement permanence — stay placed across rounds?
8. Coins shared or per-player?

## Success metrics

- Avg session length ≥ 25 min
- Round 5 completion ≥ 60% of started runs
- Round 10 completion ≥ 25%
- Gamepass conversion 3-5% of WAU
- D1 / D7 retention ≥ 35% / 12%

## Risks

See `SPEC.md` § Risks & Mitigations. Top three:

1. Roblox loot-box rules — keep rolls free, odds visible, no Robux rerolls.
2. Placement abuse — server-side pathfinding validation, see `src/server/Placement.luau`.
3. Tutorial friction — the roll-carry-place flow is novel; round 1 must teach it.
