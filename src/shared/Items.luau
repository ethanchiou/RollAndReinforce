--!strict
-- Item database. The full catalog lives in docs/item-database.md; this module is
-- the runtime source of truth. Add/edit items here and keep docs in sync.

local Types = require(script.Parent.Types)

type ItemDefinition = Types.ItemDefinition

local Items: { [string]: ItemDefinition } = {
	-- ─── Common (retention: 1 round) ────────────────────────────────
	tarnished_coin = {
		id = "tarnished_coin",
		name = "Tarnished Coin",
		rarity = "Common",
		retentionRounds = 1,
		placementCategory = "Small",
		sellValue = 10,
	},
	dusty_locket = {
		id = "dusty_locket",
		name = "Dusty Locket",
		rarity = "Common",
		retentionRounds = 1,
		placementCategory = "Small",
		sellValue = 12,
	},
	cracked_bottle = {
		id = "cracked_bottle",
		name = "Cracked Bottle",
		rarity = "Common",
		retentionRounds = 1,
		placementCategory = "Small",
		sellValue = 8,
	},

	-- ─── Uncommon (retention: 2 rounds) ─────────────────────────────
	silver_ring = {
		id = "silver_ring",
		name = "Silver Ring",
		rarity = "Uncommon",
		retentionRounds = 2,
		placementCategory = "Small",
		sellValue = 30,
	},
	old_pocketwatch = {
		id = "old_pocketwatch",
		name = "Old Pocketwatch",
		rarity = "Uncommon",
		retentionRounds = 2,
		placementCategory = "Small",
		sellValue = 35,
		roundModifier = {
			id = "passive_scrap_drip",
			description = "+1 scrap every 10s while placed.",
			effects = { scrapPerTen = 1 },
		},
	},

	-- ─── Rare (retention: 3 rounds) ─────────────────────────────────
	ornate_dagger = {
		id = "ornate_dagger",
		name = "Ornate Dagger",
		rarity = "Rare",
		retentionRounds = 3,
		placementCategory = "Medium",
		sellValue = 75,
	},
	gilded_chalice = {
		id = "gilded_chalice",
		name = "Gilded Chalice",
		rarity = "Rare",
		retentionRounds = 3,
		placementCategory = "Medium",
		sellValue = 90,
		roundModifier = {
			id = "coin_bonus_small",
			description = "+10% coins from kills while placed.",
			effects = { coinMultiplier = 0.10 },
		},
	},

	-- ─── Epic (retention: 5 rounds) ─────────────────────────────────
	ancient_relic = {
		id = "ancient_relic",
		name = "Ancient Relic",
		rarity = "Epic",
		retentionRounds = 5,
		placementCategory = "Large",
		sellValue = 200,
		roundModifier = {
			id = "spitter_debuff",
			description = "Spitters deal -50% damage while placed.",
			effects = { spitterDamageMult = -0.5 },
		},
	},
	gemstone_idol = {
		id = "gemstone_idol",
		name = "Gemstone Idol",
		rarity = "Epic",
		retentionRounds = 5,
		placementCategory = "Large",
		sellValue = 240,
		roundModifier = {
			id = "scrap_bonus",
			description = "+25% scrap from kills while placed.",
			effects = { scrapMultiplier = 0.25 },
		},
	},

	-- ─── Legendary (retention: 8-10 rounds) ─────────────────────────
	crown_of_ash = {
		id = "crown_of_ash",
		name = "Crown of Ash",
		rarity = "Legendary",
		retentionRounds = 10,
		placementCategory = "Large",
		sellValue = 800,
		roundModifier = {
			id = "legendary_aura",
			description = "All zombies take +15% damage while placed.",
			effects = { zombieDamageMult = 0.15 },
		},
	},
}

local Module = {}

function Module.get(id: string): ItemDefinition?
	return Items[id]
end

function Module.all(): { ItemDefinition }
	local list = {}
	for _, item in Items do
		table.insert(list, item)
	end
	return list
end

function Module.byRarity(rarity: Types.Rarity): { ItemDefinition }
	local list = {}
	for _, item in Items do
		if item.rarity == rarity then
			table.insert(list, item)
		end
	end
	return list
end

return Module
