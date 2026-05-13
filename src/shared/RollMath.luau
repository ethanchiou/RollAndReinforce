--!strict
-- Roll math: rarity weighting and modifier application.
--
-- IMPORTANT: this module accepts a `modifiers` parameter even in MVP (where the
-- list is always empty). The Balatro v2 joker system will pass modifiers in
-- without needing to rewrite this pipeline. Do not hardcode rarity weights at
-- call sites — pass them in.

local Types = require(script.Parent.Types)
local Items = require(script.Parent.Items)

type Rarity = Types.Rarity
type RarityWeights = Types.RarityWeights
type RollModifier = Types.RollModifier
type RollResult = Types.RollResult

local Module = {}

-- Default MVP weights. Sum doesn't need to be 1; the picker normalizes.
Module.DEFAULT_WEIGHTS = {
	Common = 50,
	Uncommon = 28,
	Rare = 14,
	Epic = 6,
	Legendary = 2,
} :: RarityWeights

-- Apply a list of roll modifiers to base weights, returning adjusted weights.
function Module.applyModifiers(base: RarityWeights, modifiers: { RollModifier }): RarityWeights
	local adjusted: RarityWeights = table.clone(base)

	for _, mod in modifiers do
		if mod.rarityMultipliers then
			for rarity, mult in mod.rarityMultipliers do
				adjusted[rarity] = (adjusted[rarity] or 0) * mult
			end
		end
		if mod.forbidRarities then
			for rarity, forbidden in mod.forbidRarities do
				if forbidden then
					adjusted[rarity] = 0
				end
			end
		end
	end

	return adjusted
end

-- Pick a rarity by weighted random. `rng` lets callers inject a seeded Random
-- for tests; pass `Random.new()` or omit for non-deterministic use.
function Module.pickRarity(weights: RarityWeights, rng: Random?): Rarity
	local r = rng or Random.new()

	local total = 0
	for _, w in weights do
		total += w
	end
	assert(total > 0, "RollMath.pickRarity: all weights are zero")

	local roll = r:NextNumber(0, total)
	local acc = 0
	for rarity, w in weights do
		acc += w
		if roll <= acc then
			return rarity
		end
	end

	-- Fallback (floating-point edge case)
	return "Common"
end

-- Pick a random item of the given rarity.
function Module.pickItemOfRarity(rarity: Rarity, rng: Random?): Types.ItemDefinition
	local r = rng or Random.new()
	local pool = Items.byRarity(rarity)
	assert(#pool > 0, `RollMath.pickItemOfRarity: no items defined for rarity "{rarity}"`)
	return pool[r:NextInteger(1, #pool)]
end

-- Top-level roll. Accepts base weights and a list of modifiers (may be empty).
-- Returns the rolled item plus an optional round modifier (for the slot's
-- "second reel" — currently unused in MVP signature; reserved for v2).
function Module.rollItem(
	weights: RarityWeights,
	modifiers: { RollModifier },
	rng: Random?
): RollResult
	local r = rng or Random.new()
	local adjusted = Module.applyModifiers(weights, modifiers)
	local rarity = Module.pickRarity(adjusted, r)
	local item = Module.pickItemOfRarity(rarity, r)

	return {
		item = item,
		roundModifier = nil, -- TODO(v2): roll an optional round-wide modifier
	}
end

return Module
