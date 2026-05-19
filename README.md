# Roll & Reinforce

> Working title. Co-op (2-4) first-person zombie-fortress defense on Roblox. Roll a slot machine each round → carry the rolled item into the fortress → place it → defend it through waves of varied zombies. Survive enough rounds and the item is permanently "banked." Lose the fortress and unbanked items are forfeit.

**Status:** Pre-implementation. Scaffolding only — no gameplay yet.

## Quick start

```bash
aftman install            # one-time per clone: pins rojo 7.4.4 + wally 0.3.2
rojo serve                # starts the sync server on localhost:34872
```

Then in Roblox Studio: File → New Baseplate → Plugins tab → **Rojo** → Connect. Press Play; you should see `[RollAndReinforce] Server bootstrapping…` in the Output panel.

Tooling sanity checks:

```bash
selene src                # 0 errors / 0 warnings expected
stylua --check src        # clean diff expected
rojo build default.project.json --output build.rbxl
```

## Project layout

```
RollAndReinforce/
├── SPEC.md              ← what we're building (read this first)
├── TODO.md              ← week-by-week implementation checklist
├── STATUS.md            ← point-in-time build snapshot
├── CLAUDE.md            ← guidance for Claude Code sessions
├── default.project.json ← Rojo project file
├── aftman.toml          ← toolchain pins (rojo, wally)
├── wally.toml           ← Luau package deps
├── selene.toml          ← linter config (std = roblox+testez)
├── testez.yml           ← TestEZ globals for selene
├── stylua.toml          ← formatter config
├── .gitattributes       ← LF line endings repo-wide
├── Packages/            ← Wally-managed; .gitkeep placeholder
├── src/
│   ├── client/          ← LocalScripts (UI, input, camera, placement preview)
│   ├── server/          ← ServerScripts (waves, economy, persistence, validation)
│   ├── shared/          ← ModuleScripts (item db, roll math, types — both sides)
│   └── tests/           ← TestEZ unit tests
└── docs/
    ├── design-doc.md    ← full game design doc
    └── item-database.md ← rolls + items + economy spreadsheet
```

## Reference

- Approved plan: `~/.claude/plans/you-are-expert-game-kind-hinton.md`
- Origin: spun out of brainstorm in `S26 Startups/Hatchware` workspace, 2026-05-12

## Engine choice

Roblox (Luau). See `SPEC.md` § Engine for the rationale.

## License

TBD. Default to "all rights reserved" until decided.
