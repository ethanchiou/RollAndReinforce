--!strict
-- Shared type definitions used by client, server, and tests.

export type Rarity = "Common" | "Uncommon" | "Rare" | "Epic" | "Legendary"

export type PlacementCategory = "Small" | "Medium" | "Large"

export type ItemDefinition = {
	id: string,
	name: string,
	rarity: Rarity,
	retentionRounds: number,
	placementCategory: PlacementCategory,
	sellValue: number,
	roundModifier: RoundModifier?,
}

export type RoundModifier = {
	id: string,
	description: string,
	-- Concrete effect ids consumed by gameplay systems. Keep additive so
	-- the Balatro v2 joker system can stack effects without rewriting.
	effects: { [string]: number },
}

export type RarityWeights = { [Rarity]: number }

export type RollModifier = {
	-- Multiplicative adjustments to rarity weights (e.g. {Legendary = 1.1} = +10%)
	rarityMultipliers: { [Rarity]: number }?,
	-- Forced rarity floor — e.g. "no Common rolls this round"
	forbidRarities: { [Rarity]: boolean }?,
}

export type RollResult = {
	item: ItemDefinition,
	roundModifier: RoundModifier?,
}

export type ZombieKind = "Walker" | "Runner" | "Brute" | "Climber" | "Spitter"

export type WaveDefinition = {
	round: number,
	spawns: { { kind: ZombieKind, count: number, delay: number } },
	durationSeconds: number,
}

export type PlacedItem = {
	itemId: string,
	roundsRemaining: number,
	position: Vector3,
	ownerUserId: number,
}

return {}
