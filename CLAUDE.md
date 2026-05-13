# CLAUDE.md

Project-specific Claude Code guidance. Read alongside `~/.claude/CLAUDE.md` (global) and `~/Desktop/CLAUDE.md` (workspace-level).

> ## Project summary
>
> **Roll & Reinforce** (working title) — co-op (2-4) first-person zombie-fortress defense on Roblox. Each round: roll a slot machine → carry the rolled item into the fortress → place it → defend through waves. Items "bank" after their rarity-tier survival count; unbanked items lost if fortress falls.
>
> Currently at **scaffolding stage**. Docs and skeleton modules only — no gameplay implemented.
>
> _Rewrite this block (don't append) when state changes materially._

## File conventions

- **`SPEC.md`** — source of truth for *what's built and what we're building*. First section, **Recently Done**, lists completed scope so an agent can see current state at a glance. When a `TODO.md` item ships, move it into Recently Done.
- **`TODO.md`** — only items **not yet implemented**. As soon as something ships, delete it from `TODO.md` and add it to `SPEC.md` → Recently Done.
- **`CLAUDE.md`** — this file. The blockquote at the top is the project summary; rewrite (not append) when state changes.
- **`docs/`** — long-form design docs (item database, design rationale). Reference, not changelog.

## Engine + tooling

- **Roblox Studio** (Luau)
- **Rojo** — filesystem ↔ Studio sync. *All code lives on disk under `src/`*; do not check in Studio-edited code via `rbxl` files.
- **Wally** for package management (Knit, ProfileService, etc.)
- **TestEZ** for unit tests

## Layout

```
src/
├── client/      LocalScripts — UI, input, camera, first-person view, placement preview
├── server/      ServerScripts — waves, economy, persistence, validation
├── shared/      ModuleScripts — item db, roll math, types (used by both sides)
└── tests/       TestEZ unit tests
```

## Conventions

- **Luau, not Lua.** Use `--!strict` at the top of new modules. Type everything that crosses a module boundary.
- **Server is authoritative.** Clients send intents (roll, place, buy), server validates and broadcasts results. Never trust client-claimed rarities, gold, or placement positions.
- **Roll pipeline takes modifiers as a parameter.** Even in MVP (where the list is always empty), keep the signature `rollItem(weights, modifiers)` so the Balatro v2 joker system can bolt on without rewriting.
- **No Robux-cost rerolls.** Roblox's loot-box rules. Rolls free in-game-currency only.
- **Two currencies max.** Coins + Scrap. Resist adding wood/metal/etc.
- **Placement validation is server-side.** Pathfinding must reach the placed item or placement is rejected.

## Working with the design

The approved plan lives at `~/.claude/plans/you-are-expert-game-kind-hinton.md`. `SPEC.md` is the day-to-day reference; the plan is the historical decision record.

When game design decisions arise that aren't covered, update `SPEC.md` and note the decision rationale inline.

## Dev workflow

```bash
# One-time setup
aftman install         # installs Rojo, Wally, etc. from aftman.toml (TBD)
wally install          # installs Knit, ProfileService, TestEZ
rojo build default.project.json -o build.rbxlx

# Iterative dev
rojo serve default.project.json     # then connect Rojo plugin in Studio

# Tests
rojo build --test default.project.json   # or use a TestEZ runner script in Studio
```

## gstack skills

This project uses [gstack](https://github.com/anthropics/gstack). Most relevant here:

- `/plan-eng-review` — review system designs before coding (roll pipeline, wave scaling, netcode)
- `/plan-design-review` — designer review of UI/UX flows (slot machine UI, placement UX)
- `/codex` — second opinion on tricky Luau / netcode patterns
- `/review` — pre-landing diff review
- `/investigate` — root-cause debugging when stuff breaks
- `/ship`, `/land-and-deploy` — when there's a CI/CD pipeline (post-MVP)

Invoke as slash commands in conversation; don't try to call them via Bash.

## Roblox-specific gotchas

- **DataStore writes are rate-limited.** Use ProfileService — don't roll your own.
- **Remote events vs remote functions.** Remote functions block; only use them where you genuinely need a response. Default to remote events.
- **Server-side scripts cannot use `require()` on client modules** and vice versa. Shared logic goes in `src/shared/`.
- **CollectionService > parent-checking** for tagging things like zombies, items, placement spots.
- **Pathfinding** — `PathfindingService` recomputes on demand; cache paths per zombie and recompute only on layout changes.
- **Studio-checked-in code is the enemy of git.** If you edit something in Studio that should be in source, port it back to `src/` immediately.
