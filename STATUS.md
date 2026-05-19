# STATUS — Roll & Reinforce

> Point-in-time snapshot of the build. Update when material state changes (tooling installed, services running, blockers resolved). For *what we're building* see `SPEC.md`; for *what's left* see `TODO.md`.

**Last updated:** 2026-05-19
**Build phase:** Pre-implementation — scaffold verified end-to-end in Studio. **MVP zombie roster (5/5) shipped** as procedural Blender assets — Walker, Runner, Brute, Climber, Spitter, each independent `.blend` + `.fbx` under `Assets/zombies/`. Gameplay code (Week 2: slot machine UI + RollService remotes) is the next chunk.
**Host:** Windows 11 (`C:\Users\Ethan\OneDrive\Desktop\GameDev\RollAndReinforce`)
**Working title:** Roll & Reinforce (not locked)

---

## Elevator pitch

Co-op (2-4) first-person zombie-fortress defense on Roblox. Roll a slot machine → carry the rolled item into the fortress → place it → defend through waves. Items "bank" after their rarity-tier survival count; unbanked items lost if the fortress falls.

---

## What's running right now

- **Rojo serve** active on `localhost:34872` (started 2026-05-19 in the current Claude session, background task `b1rlipuvr`). Studio is currently or recently connected to it.
- **Blender MCP addon** listening on `:9876`. Default scene (Cube/Light/Camera) is present. Hyper3D Rodin + Hunyuan3D AI-gen paths are **disabled** in the addon — flip the checkboxes in the BlenderMCP N-panel and reconnect to enable.

To restart Rojo manually: `rojo serve` from the project root. Port check (PowerShell): `netstat -ano | findstr :34872`.

---

## Tooling installed

| Tool | Version | Path | Notes |
|---|---|---|---|
| Aftman | 0.3.0 | `C:\Users\Ethan\.aftman\bin\aftman.exe` | ⚠️ Upstream archived. Migrate to **Rokit** before 2026-07-19. |
| Rojo | 7.4.4 (project pin) / 7.7.0-rc.1 (global) | `C:\Users\Ethan\.aftman\bin\rojo.exe` | Project-local pin in `aftman.toml`; aftman shim auto-installs on first invoke inside the project. |
| Wally | 0.3.2 | `C:\Users\Ethan\.aftman\bin\wally.exe` | No deps installed yet — entries commented in `wally.toml`. |
| Selene | 0.30.1 | `C:\Users\Ethan\.aftman\bin\selene.exe` | `selene src` returns 0/0 clean. |
| StyLua | 2.5.2 | `C:\Users\Ethan\.aftman\bin\StyLua.exe` | `stylua --check src` clean. |
| Lune | 0.10.4 | `C:\Users\Ethan\.aftman\bin\lune.exe` | Standalone Luau CLI runtime. |
| Git | 2.x | `C:\Program Files\Git\cmd\git.exe` | Git for Windows. |
| Roblox Studio | (Windows app) | `~/AppData/Local/Roblox/Versions/.../RobloxStudioBeta.exe` | Rojo plugin already installed (`Plugins/RojoManagedPlugin.rbxm` confirmed). |
| Blender | 5.1.1 | `C:\Program Files\Blender Foundation\Blender 5.1\blender.exe` | Blender MCP server registered with Claude; addon installed and listening on `:9876`. |

**Shell PATH:** `~/.aftman/bin` is already on PATH (Aftman installer added it on Windows). No shell config edits needed.

---

## Git state

```
Branch:    main
Remote:    origin → git@github.com:ethanchiou/RollAndReinforce.git
Worktree:  clean
Synced:    main is at origin/main (cleanup commits pushed 2026-05-19)
```

---

## Files on disk

```
RollAndReinforce/
├── .gitattributes              (LF line endings repo-wide)
├── .gitignore
├── README.md
├── SPEC.md                     (design source of truth)
├── TODO.md                     (implementation checklist)
├── STATUS.md                   (this file)
├── CLAUDE.md                   (agent guidance)
├── aftman.toml                 (Rojo + Wally version pins)
├── wally.toml                  (Knit/ProfileService/TestEZ commented)
├── selene.toml                 (std = "roblox+testez")
├── testez.yml                  (TestEZ globals for selene)
├── stylua.toml                 (tabs/100-col/LF/double-quotes)
├── default.project.json        (Rojo project config)
├── Packages/                   (placeholder via .gitkeep; populated by wally install)
├── Assets/
│   └── zombies/                (5 procedural Blender models, .blend + .fbx each)
│       ├── zombie-base.{blend,fbx}      (Walker — 528 tris)
│       ├── zombie-runner.{blend,fbx}    (Runner — 408 tris)
│       ├── zombie-brute.{blend,fbx}     (Brute — 600 tris)
│       ├── zombie-climber.{blend,fbx}   (Climber — 516 tris)
│       └── zombie-spitter.{blend,fbx}   (Spitter — 456 tris)
├── docs/
│   ├── design-doc.md
│   └── item-database.md
└── src/
    ├── client/init.client.luau
    ├── server/init.server.luau
    ├── server/Placement.luau
    ├── server/Waves.luau
    ├── shared/Items.luau
    ├── shared/RollMath.luau
    ├── shared/Types.luau
    └── tests/RollMath.spec.luau
```

---

## What works end-to-end

- ✅ `rojo build default.project.json` produces a valid `.rbxl` (verified 2026-05-18 on Windows).
- ✅ `selene src` clean (0 errors / 0 warnings).
- ✅ `stylua --check src` clean.
- ✅ Studio Play verified runtime — `[RollAndReinforce] Server bootstrapping…` + smoke roll + `Client bootstrapping…` all appear in Output (verified 2026-05-19).
- ✅ Default lighting (`ClockTime: 19`, dim ambient) syncs from `default.project.json` — playtest opens to the intended dusk/night scene.
- ✅ Blender MCP server bridges Claude ↔ Blender on port 9876 (verified via direct `get_scene_info` probe).
- ✅ Procedural asset pipeline: 5/5 MVP zombie models authored, joined, FBX-exported with Roblox-friendly axes (+Y up, -Z forward, meters) under `Assets/zombies/`. Each model is a single MeshPart drop-in.

## What's NOT wired yet

- ❌ No Wally deps installed (Knit, ProfileService, TestEZ are commented in `wally.toml`).
- ❌ No remote events / RemoteFunctions defined.
- ❌ No actual gameplay: no slot machine UI, no carry/place mechanic, no AI/scripts on zombies, no shop. (Models exist as art, not as wired-up gameplay entities.)
- ❌ No persistence (ProfileService not wired).
- ❌ No Studio place file saved to disk (Rojo syncs source on connect; saving `place.rbxlx` outside the repo is still on the human checklist).
- ❌ Zombie FBXs not yet imported as MeshParts in Studio — assets are on disk, tagging via `Zombie` CollectionService is pending the human Studio-side import pass.
- ❌ No fortress geometry, no spawn points (`ZombieSpawn` CollectionService tag has no instances).
- ⚠️ Hyper3D Rodin + Hunyuan3D toggles **off** in the Blender MCP N-panel — all zombies were authored via procedural `bpy` instead.

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

1. **Save the Studio place** as `place.rbxlx` outside the repo (gitignored anyway). Local workspace only; commit code only via files.
2. **Lock the 8 open decisions** in `SPEC.md` § Open Decisions. Top three: **name**, **aesthetic**, **who rolls**.
3. **Import all 5 zombie FBXs into Studio.** Each in `Assets/zombies/zombie-{base,runner,brute,climber,spitter}.fbx`. Import as MeshPart, eyeball scale against an R15 dummy (each model is built at ~5-stud height except Climber at ~6.5 and Brute at ~3.8), tag with `Zombie` + a per-type tag (`Zombie_Walker`, `Zombie_Runner`, etc.) via CollectionService. The spawner will resolve type → MeshPart by tag.

After that → week 2 begins (slot machine UI + RollService remote pipeline + full item catalog). Walker is the silhouette baseline; the other four are independent files but follow the same material conventions (shared palette + per-type EyeGlow variant).

---

## Known issues / risks

| Issue | Severity | Mitigation |
|---|---|---|
| Aftman archived, sunset 2026-07-19 | Medium | Migrate to Rokit. Manifest format is compatible — copy `aftman.toml` → `rokit.toml`, `rokit install`. |
| Project pin (Rojo 7.4.4) lags global (7.7.0-rc.1) | Low | Bump `aftman.toml` to a current Rojo when convenient; no breaking changes expected for build/serve. |
| `Packages/` populated only by Wally | Low | `.gitkeep` placeholder added so `rojo build` works on fresh clone. First `wally install` will fill it. |
| Roblox loot-box rules apply to slot machine | Medium | Documented in SPEC § Risks. Rolls free, odds visible, no Robux-cost rerolls — confirmed in design. |
