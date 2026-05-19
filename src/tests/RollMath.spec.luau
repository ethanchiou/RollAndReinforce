--!strict
-- TestEZ specs for roll math.
-- Run via a TestEZ runner script in Studio, or via lune/run-in-roblox in CI.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RollMath = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RollMath"))

return function()
	describe("RollMath.applyModifiers", function()
		it("returns base weights when modifiers is empty", function()
			local base = { Common = 50, Uncommon = 25, Rare = 15, Epic = 7, Legendary = 3 }
			local out = RollMath.applyModifiers(base, {})
			expect(out.Common).to.equal(50)
			expect(out.Legendary).to.equal(3)
		end)

		it("multiplies rarity weights", function()
			local base = { Common = 50, Uncommon = 25, Rare = 15, Epic = 7, Legendary = 3 }
			local out = RollMath.applyModifiers(base, {
				{ rarityMultipliers = { Legendary = 2.0 } },
			})
			expect(out.Legendary).to.equal(6)
			expect(out.Common).to.equal(50)
		end)

		it("zeroes out forbidden rarities", function()
			local base = { Common = 50, Uncommon = 25, Rare = 15, Epic = 7, Legendary = 3 }
			local out = RollMath.applyModifiers(base, {
				{ forbidRarities = { Common = true } },
			})
			expect(out.Common).to.equal(0)
			expect(out.Uncommon).to.equal(25)
		end)
	end)

	describe("RollMath.pickRarity", function()
		it("respects weight distribution within 5% over 10k samples", function()
			local rng = Random.new(12345)
			local base = { Common = 50, Uncommon = 25, Rare = 15, Epic = 7, Legendary = 3 }
			local counts = { Common = 0, Uncommon = 0, Rare = 0, Epic = 0, Legendary = 0 }
			local N = 10000
			for _ = 1, N do
				local r = RollMath.pickRarity(base, rng)
				counts[r] += 1
			end

			local function pct(c)
				return c / N * 100
			end
			expect(math.abs(pct(counts.Common) - 50)).to.be.near(0, 3)
			expect(math.abs(pct(counts.Uncommon) - 25)).to.be.near(0, 3)
			expect(math.abs(pct(counts.Rare) - 15)).to.be.near(0, 3)
			expect(math.abs(pct(counts.Epic) - 7)).to.be.near(0, 2)
			expect(math.abs(pct(counts.Legendary) - 3)).to.be.near(0, 1.5)
		end)
	end)

	describe("RollMath.rollItem", function()
		it("returns a result with an item", function()
			local result = RollMath.rollItem(RollMath.DEFAULT_WEIGHTS, {}, Random.new(1))
			expect(result.item).to.be.ok()
			expect(result.item.id).to.be.a("string")
		end)
	end)
end
