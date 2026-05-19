--!strict
-- Server-side placement validation.
--
-- Players propose a placement; this module decides whether it's allowed.
-- Anti-cheese rule: at least one spawn point must be able to path to the
-- proposed item position. Without this, players hide items in unreachable
-- corners and trivialize the round.

local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Types = require(Shared:WaitForChild("Types"))
local Items = require(Shared:WaitForChild("Items"))

type PlacedItem = Types.PlacedItem

local Module = {}

export type PlacementResult = {
	ok: boolean,
	reason: string?,
	placed: PlacedItem?,
}

-- Tag your spawn points with CollectionService tag "ZombieSpawn" in Studio.
local function getSpawnPoints(): { Vector3 }
	local CollectionService = game:GetService("CollectionService")
	local points = {}
	for _, inst in CollectionService:GetTagged("ZombieSpawn") do
		if inst:IsA("BasePart") then
			table.insert(points, inst.Position)
		end
	end
	return points
end

local function pathExists(from: Vector3, to: Vector3): boolean
	local path = PathfindingService:CreatePath({
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true,
		AgentJumpHeight = 8,
		AgentMaxSlope = 45,
	})

	local ok, err = pcall(function()
		path:ComputeAsync(from, to)
	end)

	if not ok then
		warn("Placement.pathExists ComputeAsync error:", err)
		return false
	end

	return path.Status == Enum.PathStatus.Success
end

-- Validate a proposed placement. Server only.
function Module.validate(itemId: string, position: Vector3, ownerUserId: number): PlacementResult
	local item = Items.get(itemId)
	if not item then
		return { ok = false, reason = "Unknown item id: " .. itemId }
	end

	local spawns = getSpawnPoints()
	if #spawns == 0 then
		-- No spawn points yet (e.g. test environment) — accept by default.
		warn("Placement.validate: no ZombieSpawn-tagged parts found; skipping reachability check")
	else
		local reachable = false
		for _, spawn in spawns do
			if pathExists(spawn, position) then
				reachable = true
				break
			end
		end
		if not reachable then
			return {
				ok = false,
				reason = "No zombie can path to this spot. Place somewhere reachable.",
			}
		end
	end

	local placed: PlacedItem = {
		itemId = itemId,
		roundsRemaining = item.retentionRounds,
		position = position,
		ownerUserId = ownerUserId,
	}

	return { ok = true, placed = placed }
end

-- Decrement remaining rounds on every placed item at end of round.
-- Returns the list of items that just banked (rounds reached 0).
function Module.tickRound(placed: { PlacedItem }): { PlacedItem }
	local banked = {}
	for _, p in placed do
		p.roundsRemaining -= 1
		if p.roundsRemaining <= 0 then
			table.insert(banked, p)
		end
	end
	return banked
end

return Module
