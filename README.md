# Roll & Reinforce

> Working title. Co-op (2-4) first-person zombie-fortress defense on Roblox. Roll a slot machine each round → carry the rolled item into the fortress → place it → defend it through waves of varied zombies. Survive enough rounds and the item is permanently "banked." Lose the fortress and unbanked items are forfeit.

**Status:** Pre-implementation. Scaffolding only — no gameplay yet.

## Quick start (once Rojo is installed)

```bash
# Install Rojo (one-time, requires aftman or foreman, or download from rojo.space)
rojo serve default.project.json
# Then in Roblox Studio: install Rojo plugin, connect on port 34872
```

## Project layout

```
RollAndReinforce/
├── SPEC.md             ← what we're building (read this first)
├── TODO.md             ← week-by-week implementation checklist
├── CLAUDE.md           ← guidance for Claude Code sessions
├── default.project.json ← Rojo project file
├── src/
│   ├── client/         ← LocalScripts (UI, input, camera, placement preview)
│   ├── server/         ← ServerScripts (waves, economy, persistence, validation)
│   ├── shared/         ← ModuleScripts (item db, roll math, types — used by both sides)
│   └── tests/          ← TestEZ unit tests
├── assets/             ← models, sounds, UI exports (binary, gitignored or LFS)
└── docs/
    ├── design-doc.md   ← full game design doc
    └── item-database.md ← rolls + items + economy spreadsheet
```

## Reference

- Approved plan: `~/.claude/plans/you-are-expert-game-kind-hinton.md`
- Origin: spun out of brainstorm in `S26 Startups/Hatchware` workspace, 2026-05-12

## Engine choice

Roblox (Luau). See `SPEC.md` § Engine for the rationale.

## License

TBD. Default to "all rights reserved" until decided.
