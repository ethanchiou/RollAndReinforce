# STATUS — Roll & Reinforce

> Point-in-time snapshot of the build. Update when material state changes (tooling installed, services running, blockers resolved). For *what we're building* see `SPEC.md`; for *what's left* see `TODO.md`.

**Last updated:** 2026-05-19
**Build phase:** Pre-implementation — scaffold verified end-to-end in Studio (Play → Output shows bootstrap + smoke roll). Blender MCP bridge live. Art pipeline kicking off (first zombie). Gameplay code (Week 2) next.
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

## What's NOT wired yet

- ❌ No Wally deps installed (Knit, ProfileService, TestEZ are commented in `wally.toml`).
- ❌ No remote events / RemoteFunctions defined.
- ❌ No actual gameplay: no slot machine UI, no carry/place mechanic, no zombies, no shop.
- ❌ No persistence (ProfileService not wired).
- ❌ No Studio place file saved to disk (Rojo syncs source on connect; saving `place.rbxlx` outside the repo is still on the human checklist).
- ❌ No fortress geometry, no spawn points (`ZombieSpawn` CollectionService tag has no instances).
- ⚠️ Hyper3D Rodin + Hunyuan3D toggles **off** in the Blender MCP N-panel — first asset will be procedural `bpy` rather than AI-generated.

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
3. **Drop the base zombie FBX into Studio.** After the procedural asset lands in `Assets/zombies/`, import as MeshPart, eyeball scale against an R15 dummy, tag with `Zombie` via CollectionService. Iterate the script if proportions feel off.

After that → week 2 begins (slot machine UI + RollService remote pipeline + full item catalog), and the rest of the zombie roster gets silhouette-edited from the Walker base.

---

## Known issues / risks

| Issue | Severity | Mitigation |
|---|---|---|
| Aftman archived, sunset 2026-07-19 | Medium | Migrate to Rokit. Manifest format is compatible — copy `aftman.toml` → `rokit.toml`, `rokit install`. |
| Project pin (Rojo 7.4.4) lags global (7.7.0-rc.1) | Low | Bump `aftman.toml` to a current Rojo when convenient; no breaking changes expected for build/serve. |
| `Packages/` populated only by Wally | Low | `.gitkeep` placeholder added so `rojo build` works on fresh clone. First `wally install` will fill it. |
| Roblox loot-box rules apply to slot machine | Medium | Documented in SPEC § Risks. Rolls free, odds visible, no Robux-cost rerolls — confirmed in design. |
