--!strict
-- Server entry point. Placeholder — wire up Knit + services as they're built.

print("[RollAndReinforce] Server bootstrapping…")

-- Lazy require so partial scaffolds don't crash on missing modules.
local function safeRequire(parent: Instance, name: string)
	local child = parent:FindFirstChild(name)
	if child and child:IsA("ModuleScript") then
		local ok, mod = pcall(require, child)
		if ok then
			return mod
		end
		warn("[RollAndReinforce] failed to require", name, mod)
	end
	return nil
end

-- Smoke-check that shared modules load.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Items = safeRequire(Shared, "Items")
local RollMath = safeRequire(Shared, "RollMath")

if Items and RollMath then
	print(`[RollAndReinforce] Loaded {#Items.all()} items.`)
	local result = RollMath.rollItem(RollMath.DEFAULT_WEIGHTS, {}, Random.new())
	print(`[RollAndReinforce] Smoke roll: {result.item.rarity} — {result.item.name}`)
end

print("[RollAndReinforce] Server ready.")
