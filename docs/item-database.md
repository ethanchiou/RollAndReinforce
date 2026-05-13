# Item Database

Design reference for the rolled-item catalog. Runtime source of truth is `src/shared/Items.luau` — keep this doc in sync when items change.

## Rarity tiers and retention schedule

| Rarity | Roll weight | Retention rounds | Sell value range | Footprint |
|---|---|---|---|---|
| Common | 50 | 1 | 8 – 15 coins | Small |
| Uncommon | 28 | 2 | 25 – 40 coins | Small / Medium |
| Rare | 14 | 3 | 60 – 100 coins | Medium |
| Epic | 6 | 5 | 175 – 275 coins | Large |
| Legendary | 2 | 8 – 10 | 700 – 1000 coins | Large |

Sell value rule of thumb: roughly equal to "coins earned from surviving the required rounds × 0.6" — so banking is meaningfully better than insta-selling, but selling is a viable fallback when the run looks shaky.

## Initial catalog (12 items, MVP-shippable)

### Common — retention 1

| ID | Name | Sell | Modifier |
|---|---|---|---|
| `tarnished_coin` | Tarnished Coin | 10 | — |
| `dusty_locket` | Dusty Locket | 12 | — |
| `cracked_bottle` | Cracked Bottle | 8 | — |

### Uncommon — retention 2

| ID | Name | Sell | Modifier |
|---|---|---|---|
| `silver_ring` | Silver Ring | 30 | — |
| `old_pocketwatch` | Old Pocketwatch | 35 | +1 scrap every 10s while placed |

### Rare — retention 3

| ID | Name | Sell | Modifier |
|---|---|---|---|
| `ornate_dagger` | Ornate Dagger | 75 | — |
| `gilded_chalice` | Gilded Chalice | 90 | +10% coins from kills while placed |

### Epic — retention 5

| ID | Name | Sell | Modifier |
|---|---|---|---|
| `ancient_relic` | Ancient Relic | 200 | Spitters deal -50% damage while placed |
| `gemstone_idol` | Gemstone Idol | 240 | +25% scrap from kills while placed |

### Legendary — retention 10

| ID | Name | Sell | Modifier |
|---|---|---|---|
| `crown_of_ash` | Crown of Ash | 800 | All zombies take +15% damage while placed |

## Items to add before week 8 (target: 15-20 total)

Stretch items to flesh out the catalog. Naming + effects can be tuned during balance pass.

- **Uncommon:** rusted key (opens 1 free shop reroll), tin compass (revealing minimap pings extend further)
- **Rare:** charred journal (+1 max reinforcement this round), bone whistle (1 free wood-tier wall placement)
- **Epic:** sapphire eye (legendary roll odds +5% next round only), iron ledger (sell prices +30% next round)
- **Legendary:** obsidian crown (alternate Legendary, retention 8, "first wave of each round is 50% smaller"), heart of the warden (retention 10, "downed teammates revive for free")

## Modifier design rules

1. **No mandatory placement.** Modifiers should be valuable but not strictly required to win the round — placement is the player's call.
2. **Effects must be readable.** "Spitters -50% dmg" is good. "Stochastic +X% Y" is bad.
3. **Stacking is fine.** If a player has two Gilded Chalices placed, +20% coins. The Balatro v2 system will lean on this.
4. **No "infinite scaling" effects.** Anything that compounds (like +X% per kill, no cap) must have a cap.

## Open balance questions

- Are Common items worth keeping at all if their sell value barely matters? Lean: yes, because they round-bank in 1 round and accumulate in long runs.
- Should banked Legendaries provide a permanent meta-bonus per run (e.g. "you've banked Crown of Ash → start each run with +10 scrap")? Defer to meta-progression design.
- Should some items occupy *the* objective slot (zombies path to them specifically) while others are passive trinkets? Currently every placed item is targeted. Consider: only the highest-rarity placed item is the objective, the rest are passive.

## V2 catalog directions (post-MVP)

- Jokers (Balatro-style): modifiers that persist across rounds, sit in a separate slot, never need protecting. See `SPEC.md` § Slot Machine V2.
- Set bonuses: bank 3 Common items in one run for a meta unlock.
- Cursed items: very high sell value but with downsides ("+50% sell, but spawns 2 extra Brutes per wave").
