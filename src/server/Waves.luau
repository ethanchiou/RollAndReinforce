--!strict
-- Wave definitions and spawn scaling.
--
-- Wave intensity scales with:
--   1. Round number (linear-ish curve with breakpoints)
--   2. Player count (sub-linear: 4p ≈ 2.5× solo, not 4×)
--
-- Concrete spawn lists for early rounds are hand-authored for tutorial-feel;
-- mid/late rounds are procedural off scaling formulas.

local Types =
	require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Types"))

type WaveDefinition = Types.WaveDefinition
type ZombieKind = Types.ZombieKind

local Module = {}

-- Sub-linear player-count multiplier. 1p = 1.0, 2p = 1.6, 3p = 2.1, 4p = 2.5.
local PLAYER_COUNT_MULT: { number } = { 1.0, 1.6, 2.1, 2.5 }

function Module.playerCountMultiplier(playerCount: number): number
	local clamped = math.clamp(playerCount, 1, 4)
	return PLAYER_COUNT_MULT[clamped]
end

-- Hand-authored early rounds (tutorial feel).
local EARLY_WAVES: { WaveDefinition } = {
	{
		round = 1,
		spawns = {
			{ kind = "Walker", count = 8, delay = 2.0 },
		},
		durationSeconds = 90,
	},
	{
		round = 2,
		spawns = {
			{ kind = "Walker", count = 12, delay = 1.6 },
			{ kind = "Runner", count = 3, delay = 4.0 },
		},
		durationSeconds = 100,
	},
	{
		round = 3,
		spawns = {
			{ kind = "Walker", count = 14, delay = 1.4 },
			{ kind = "Runner", count = 5, delay = 3.0 },
			{ kind = "Brute", count = 1, delay = 30.0 },
		},
		durationSeconds = 120,
	},
}

-- Procedural scaling for rounds 4+. Hand-authored rounds take precedence if defined.
local function proceduralWave(round: number): WaveDefinition
	local intensity = 1 + (round - 1) * 0.35
	local spawns = {
		{
			kind = "Walker" :: ZombieKind,
			count = math.floor(10 * intensity),
			delay = math.max(0.4, 1.6 - round * 0.05),
		},
		{
			kind = "Runner" :: ZombieKind,
			count = math.floor(3 * intensity),
			delay = math.max(0.6, 3.0 - round * 0.08),
		},
	}
	if round >= 4 then
		table.insert(spawns, {
			kind = "Brute" :: ZombieKind,
			count = math.floor(1 + (round - 4) * 0.5),
			delay = 20.0,
		})
	end
	if round >= 5 then
		table.insert(spawns, {
			kind = "Climber" :: ZombieKind,
			count = math.floor(1 + (round - 5) * 0.4),
			delay = 12.0,
		})
	end
	if round >= 7 then
		table.insert(spawns, {
			kind = "Spitter" :: ZombieKind,
			count = math.floor(1 + (round - 7) * 0.3),
			delay = 18.0,
		})
	end

	return {
		round = round,
		spawns = spawns,
		durationSeconds = 120 + math.min(60, (round - 1) * 5),
	}
end

function Module.getWave(round: number, playerCount: number): WaveDefinition
	local base: WaveDefinition
	if EARLY_WAVES[round] then
		base = EARLY_WAVES[round]
	else
		base = proceduralWave(round)
	end

	local mult = Module.playerCountMultiplier(playerCount)
	local scaledSpawns = {}
	for _, spawn in base.spawns do
		table.insert(scaledSpawns, {
			kind = spawn.kind,
			count = math.max(1, math.floor(spawn.count * mult)),
			delay = spawn.delay,
		})
	end

	return {
		round = base.round,
		spawns = scaledSpawns,
		durationSeconds = base.durationSeconds,
	}
end

return Module
