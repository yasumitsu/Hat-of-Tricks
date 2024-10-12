if CurrentModOptions["LOOT_DROP_PROBABILITY"] == "Default" then
	return end

-- OnMsg.ExplorationStart
OnMsg.CombatStart = function()
	-- print("OnMsg.CombatStart")
	for _, unit in pairs(GetNonPlayerUnits()) do
		ChangeDropChance(unit)
	end
end

function ChangeDropChance(unit)
	local LOOT_DROP_PROBABILITY_MAP = { Half = 0.5, Double = 2, Triple = 3, All = 100 }
	local probability = LOOT_DROP_PROBABILITY_MAP[CurrentModOptions["LOOT_DROP_PROBABILITY"]]
	
	unit:ForEachItem(function(item, slot_name)
		if probability == 100 then
			item.drop_chance = 100
		else
			local dropChance = {
				['Ammo'] = probability * const.BaseDropChance.Ammo, 
				['Armor'] = probability * const.BaseDropChance.Armor, 
				['ConditionAndRepair'] = probability * const.BaseDropChance.ConditionAndRepair,
				['Firearm'] = probability * const.BaseDropChance.Firearm, 
				['Grenade'] = probability * const.BaseDropChance.Grenade, 
				['HeavyWeapon'] = probability * const.BaseDropChance.HeavyWeapon,
				['Medicine'] = probability * const.BaseDropChance.Medicine,
				['MeleeWeapon'] = probability * const.BaseDropChance.MeleeWeapon,
				['Ordnance'] = probability * const.BaseDropChance.Ordnance,
				['QuestItem'] = probability * const.BaseDropChance.QuestItem,
				['QuickSlotItem'] = probability * const.BaseDropChance.QuickSlotItem,
				['ResourceItem'] = probability * const.BaseDropChance.ResourceItem,
				['ToolItem'] = probability * const.BaseDropChance.ToolItem,
				['Valuables'] = probability * const.BaseDropChance.Valuables,				
			}
			for lootType, chance in pairs(dropChance) do
				if IsKindOf(item, lootType) then 
					if chance > 100 then
						item.drop_chance = 100
					else
						item.drop_chance = chance
					end
					break
				end
			end			
		end
	end)
end


function GetNonPlayerUnits()
	
	local humanFractions = {"neutral", "player1", "player2", "enemy1", "enemy2", "enemyNeutral", "ally"}
	local playerFractions = {"player1", "player2"}
	
	local teams = table.ifilter(g_Teams, function(i, t)
		return table.find(humanFractions, t.side) and not table.find(playerFractions, t.side)
	end)
	
	local units = {}
	for _, team in ipairs(teams) do
		for i, u in ipairs(team.units) do
			if not u:IsDead() and u.species == "Human" then
				table.insert(units, u)
			end
		end	
	end
	
	return units
end