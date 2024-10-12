-- shared
CustomSettingsMod = rawget(_G, "CustomSettingsMod") or {}
CustomSettingsMod.Temp = CustomSettingsMod.Temp or {}
CustomSettingsMod.UIMods = CustomSettingsMod.UIMods or {}
local Mod = CustomSettingsMod
local Utils = Mod.Utils
local Temp = CustomSettingsMod.Temp
local UIMods = Mod.UIMods

Mod.ModId = CurrentModId
Mod.ModDef = CurrentModDef
Mod.ErrorStr = "[CUSTOM SETTINGS ERROR]"

-- alias in local scope
local table_copy_some_keys = Utils.table_copy_some_keys
local table_kvmap = Utils.table_kvmap
local round = Utils.round
local ToNumberOrDefault = Utils.ToNumberOrDefault
local IsOptionDefaultValue = Utils.IsOptionDefaultValue
local SetGlobalByPath = Utils.SetGlobalByPath

-- store default values
function GetConstDefaultValues()
	local result = {}
	for group_key, group in pairs(Presets.ConstDef) do
		if type(group_key) == "string" then
			for _, preset in pairs(group) do
				local group_id = preset.group or group_key
				if group_id == "Default" then
					result[preset.id] = preset.value
				else
					result[group_id] = result[group_id] or {}
					result[group_id][preset.id] = preset.value
				end
			end
		end
	end

	return result
end
local const_default_values = GetConstDefaultValues()
local default_Satellite = table_copy_some_keys(const_default_values.Satellite, "MercSquadMaxPeople", "MaxHiredMercs")
--local default_Imp = table_copy_some_keys(const_default_values.Imp, "MaxStatPoints")
--local default_BaseDropChance = table.copy(const_default_values.BaseDropChance)
default_EnemySquadSize = rawget(_G, "default_EnemySquadSize") or {}
local default_SatelliteSectorMaxMilitia = SatelliteSector.MaxMilitia
local default_MercMaxLevel = 10 -- #XPTable

-- mod options lookup table
Mod.OptionsLookup = {
	--["idCS_StartingMoney"] = { ["const"] = "const.Satellite.StartingMoney", ["default"] = default_Satellite.StartingMoney, ["transform_func"] = function(option_val) return string.gsub(option_val, ",", "") end }, -- default: 40,000
	["idCS_MercSquadMaxPeople"] = { ["const"] = "const.Satellite.MercSquadMaxPeople", ["default"] = default_Satellite.MercSquadMaxPeople }, -- default: 6
	["idCS_MaxHiredMercs"] = { ["const"] = "const.Satellite.MaxHiredMercs", ["default"] = default_Satellite.MaxHiredMercs }, -- default: 15
	--["idCS_IMPMaxStatPoints"] = { ["const"] = "const.Imp.MaxStatPoints", ["default"] = default_Imp.MaxStatPoints }, -- default: 550
	["idCS_IMPStatMaxValue"] = { ["const"] = nil, ["default"] = 85 }, -- default: 85
	["idCS_EnemySquadSizeMultiplier"] = { ["const"] = nil, ["default"] = 1 }, -- default: 1
	--["idCS_BaseDropChance_Ammo"] = { ["const"] = "const.BaseDropChance.Ammo", ["default"] = default_BaseDropChance.Ammo }, -- default: 7
	--["idCS_BaseDropChance_Armor"] = { ["const"] = "const.BaseDropChance.Armor", ["default"] = default_BaseDropChance.Armor }, -- default: 4
	--["idCS_BaseDropChance_ConditionAndRepair"] = { ["const"] = "const.BaseDropChance.ConditionAndRepair", ["default"] = default_BaseDropChance.ConditionAndRepair }, -- default: 30
	--["idCS_BaseDropChance_Firearm"] = { ["const"] = "const.BaseDropChance.Firearm", ["default"] = default_BaseDropChance.Firearm }, -- default: 12
	--["idCS_BaseDropChance_Grenade"] = { ["const"] = "const.BaseDropChance.Grenade", ["default"] = default_BaseDropChance.Grenade }, -- default: 5
	--["idCS_BaseDropChance_HeavyWeapon"] = { ["const"] = "const.BaseDropChance.HeavyWeapon", ["default"] = default_BaseDropChance.HeavyWeapon }, -- default: 12
	--["idCS_BaseDropChance_Medicine"] = { ["const"] = "const.BaseDropChance.Medicine", ["default"] = default_BaseDropChance.Medicine }, -- default: 100
	--["idCS_BaseDropChance_MeleeWeapon"] = { ["const"] = "const.BaseDropChance.MeleeWeapon", ["default"] = default_BaseDropChance.MeleeWeapon }, -- default: 12
	--["idCS_BaseDropChance_Ordnance"] = { ["const"] = "const.BaseDropChance.Ordnance", ["default"] = default_BaseDropChance.Ordnance }, -- default: 50
	--["idCS_BaseDropChance_QuickSlotItem"] = { ["const"] = "const.BaseDropChance.QuickSlotItem", ["default"] = default_BaseDropChance.QuickSlotItem }, -- default: 50
	--["idCS_BaseDropChance_ResourceItem"] = { ["const"] = "const.BaseDropChance.ResourceItem", ["default"] = default_BaseDropChance.ResourceItem }, -- default: 30
	--["idCS_BaseDropChance_ToolItem"] = { ["const"] = "const.BaseDropChance.ToolItem", ["default"] = default_BaseDropChance.ToolItem }, -- default: 15
	--["idCS_BaseDropChance_Valuables"] = { ["const"] = "const.BaseDropChance.Valuables", ["default"] = default_BaseDropChance.Valuables }, -- default: 100
	["idCS_SatelliteSectorMaxMilitia"] = { ["const"] = nil, ["default"] = default_SatelliteSectorMaxMilitia }, -- default: 8
	["idCS_MercMaxLevel"] = { ["const"] = nil, ["default"] = default_MercMaxLevel }, -- default: 10
}

-- locals
local ModIsBeingLoaded = true
local ModOptionsWereApplied = false
local const_min_slots = 4
local const_max_slots = 24
local GetInventoryMaxSlots_old = nil

---- init base drop chance
--local function Init_BaseDropChance()
--	-- const.BaseDropChance
--	for optKey, optVal in pairs(Mod.OptionsLookup) do
--		local typeName = string.gsub(optKey, "idCS_BaseDropChance_", "")
--		if typeName then
--			for clsKey, clsVal in pairs(g_Classes) do
--				if clsVal.IsKindOf and clsVal:IsKindOf(typeName) then
--					clsVal.base_drop_chance = ToNumberOrDefault(CurrentModOptions[optKey], optVal.default)
--				end
--			end
--		end
--    end
--end

-- init custom const values
local function Init_Constants()
	-- set all const values in the OptionsLookup table
	for option_id, l in pairs(Mod.OptionsLookup) do
		if l.const ~= nil then
			local v = l.transform_func and l.transform_func(CurrentModOptions[option_id]) or CurrentModOptions[option_id]
			SetGlobalByPath(l.const, ToNumberOrDefault(v, l.default))
		end
	end
end

--local function Run_UnlockIMP()
--	if CurrentModOptions["idCS_UnlockIMP"] then
--		g_ImpTest = false
--	end
--end

--local function Init_IMPMaxStat()
--	if IsOptionDefaultValue("idCS_IMPStatMaxValue") ~= true then
--		local ImpGetMinMaxStat_old = ImpGetMinMaxStat
--		ImpGetMinMaxStat = function(stat_id)
--			local min, max = ImpGetMinMaxStat_old(stat_id)
--			return min, tonumber(CurrentModOptions["idCS_IMPStatMaxValue"])
--		end
--	end
--end

local function Init_EnemySquadSizeMultiplier()
	-- needs to run even if setting == [default] in order to reset edits when
	-- setting == [not default], and then changed to [default] without a game restart
	local multiplier = tonumber(CurrentModOptions["idCS_EnemySquadSizeMultiplier"]) or Mod.OptionsLookup["idCS_EnemySquadSizeMultiplier"].default
	for _, v in pairs(EnemySquadDefs) do
		for _, u in ipairs(v.Units) do
			local skip = false
			for _, w in ipairs(u.weightedList) do
				local ud = UnitDataDefs[w.unitType]
				-- skip some "unique" type units
				if ud.ImportantNPC == true
					or ud.role == "Commander"
					or ud.group == "MercenariesNew"
					or ud.group == "MercenariesOld"
					or ud.militia == true then
					skip = true
				end
			end
			
			if skip == false then
				-- save the default values
				local saved = default_EnemySquadSize[u]
				if saved == nil then
					saved = { ["UnitCountMin"] = u.UnitCountMin, ["UnitCountMax"] = u.UnitCountMax }
					default_EnemySquadSize[u] = saved
				end

				u.UnitCountMin = round(saved.UnitCountMin * multiplier)
				u.UnitCountMax = round(saved.UnitCountMax * multiplier)
			end
		end
	end
end

-- disable MinFreeMove perk on NPCs
--local function Init_DisableMinFreeMovePerkOnNPCs()
--	if CurrentModOptions["idCS_DisableMinFreeMovePerkOnNPCs"] then
--		for k, u in pairs(UnitDataDefs) do
--			if not u.IsMercenary then
--				-- UnitData
--				local i = table.find(u.StartingPerks, "MinFreeMove")
--				if i then
--					table.remove(u.StartingPerks, i)
--				end
--
--				-- UnitDataCompositeDef, basically same as _G[k]
--				local uc = g_Classes[k]
--				i = table.find(uc.StartingPerks, "MinFreeMove")
--				if i then
--					table.remove(uc.StartingPerks, i)
--				end
--			end
--		end
--	end
--end

--	-- better than the default one so skip restoring if setting is disabled
--	CthVisible = function() return (gv_Cheats or false) and (gv_Cheats["ShowCth"] or false) or false end
--
--	-- enable show chance to hit
--	if CurrentModOptions["idCS_EnableShowChanceToHit"] then
--		gv_Cheats = rawget(_G, "gv_Cheats") or {}
--		NetSyncEvent("CheatEnable", "ShowCth", true)
--
--	-- disable it
--	-- if the setting was changed to disabled, but the cheat is still enabled in the game
--	elseif Temp.Prev_EnableShowChanceToHit == true and CthVisible() then
--		gv_Cheats = rawget(_G, "gv_Cheats") or {}
--		NetSyncEvent("CheatEnable", "ShowCth", false)
--	end
--
--	-- store previous value for "show chance to hit" setting
--	Temp.Prev_EnableShowChanceToHit = CurrentModOptions["idCS_EnableShowChanceToHit"]
--end
--
---- enable show chance to hit
--local function Run_EnableShowChanceToHit()
--	if table.find(ModsLoaded, "id", "KAJY0RB") then
--		return
--	end
--
--	if CurrentModOptions["idCS_EnableShowChanceToHit"] then
--		gv_Cheats = rawget(_G, "gv_Cheats") or {}
--		NetSyncEvent("CheatEnable", "ShowCth", true)
--	end
--end

-- disable some mercenaries being randomly offline on new game
--local function Init_DisableNewGameOfflineMercs()
--	if CurrentModOptions["idCS_DisableNewGameOfflineMercs"] then
--		RandomizeOfflineMercs = function() end
--	end
--end

-- set # max militia per sector
local function Init_SatelliteSectorMaxMilitia()
	if IsOptionDefaultValue("idCS_SatelliteSectorMaxMilitia") ~= true then
		SatelliteSector.MaxMilitia = tonumber(CurrentModOptions["idCS_SatelliteSectorMaxMilitia"])
	end
end

-- replacement func
local function GetInventoryMaxSlotsCustom(self)
    -- fight_club_dummy is copy of player merc and will have the same number of slots
    if IsMerc(self) then
        -- get mode
		local value = CurrentModOptions["idCS_MercInventorySizeMode"]
		local mode = nil
		local number = tonumber((string.gsub(value, "^.+:%s*", ""))) -- extra () is important
		if string.starts_with(value, "Max:") then
			mode = "Max"
		elseif  string.starts_with(value, "Multiplier:") then
			mode = "Multiplier"
		elseif  string.starts_with(value, "Add:") then
			mode = "Add"
		end

        if mode == "Multiplier" then
            -- use multiplier
            return Min(round(GetInventoryMaxSlots_old(self) * number), const_max_slots)
        elseif mode == "Add" then
            -- use addition
            return Max(Min(GetInventoryMaxSlots_old(self) + number, const_max_slots), const_min_slots)
        elseif mode == "Max" then
            -- use max
            return const_max_slots
		else
			-- disabled
			return GetInventoryMaxSlots_old(self)
        end
    else
        return GetInventoryMaxSlots_old(self)
    end
end

-- set merc inventory size mode
local function Init_MercInventorySizeMode()
	if CurrentModOptions["idCS_MercInventorySizeMode"] ~= "Disabled" then
		-- store the old func
		GetInventoryMaxSlots_old = GetInventoryMaxSlots_old or UnitData.GetInventoryMaxSlots

		-- replace 
		Unit.GetInventoryMaxSlots = GetInventoryMaxSlotsCustom
		UnitData.GetInventoryMaxSlots = GetInventoryMaxSlotsCustom
	else
		-- replace
		Unit.GetInventoryMaxSlots = GetInventoryMaxSlots_old or Unit.GetInventoryMaxSlots
		UnitData.GetInventoryMaxSlots = GetInventoryMaxSlots_old or UnitData.GetInventoryMaxSlots
	end
end

-- set merc max level
local function Init_MercMaxLevel()
	if IsOptionDefaultValue("idCS_MercMaxLevel") ~= true then
		-- store
		Temp.XPTable_old = Temp.XPTable_old or XPTable

		local new_max_level = tonumber(CurrentModOptions["idCS_MercMaxLevel"])

		-- new xp table generated using polynomial curve fitting on default xp curve
		-- xp_req = 250 * (level^2) + 250 * level - 500
		local new_xp_table = { 0, 1000, 2500, 4500, 7000, 10000, 13500, 17500, 22000, 27000, 32500, 38500, 45000, 52000, 59500, 67500, 76000, 85000, 94500, 104500, 115000, 126000, 137500, 149500, 162000, 175000, 188500, 202500, 217000, 232000, 247500, 263500, 280000, 297000, 314500, 332500, 351000, 370000, 389500, 409500, 430000, 451000, 472500, 494500, 517000, 540000 }

		-- replace old xp table
		XPTable = table.slice(new_xp_table, 1, new_max_level)
	else
		-- reset
		if Temp.XPTable_old then
			XPTable = Temp.XPTable_old
			Temp.XPTable_old = nil
		end
	end
end

-- for settings that need to be initialized before class definitions are reset on lua reload
-- enables class definitions to use these modified values rather than the game default
local function Initialize_Early()
	-- set const game variables
	if not pcall(Init_Constants) then
		print(string.format("%s Init_Constants", Mod.ErrorStr))
	end

--	-- set base drop chance (temp fix 1.3)
--	if not pcall(Init_BaseDropChance) then
--		print(string.format("%s Init_BaseDropChance", Mod.ErrorStr))
--	end

	-- set merc max level
	if not pcall(Init_MercMaxLevel) then
		print(string.format("%s Init_MercMaxLevel", Mod.ErrorStr))
	end
end

local function Initialize()
	-- set I.M.P. max stat
--	if not pcall(Init_IMPMaxStat) then
--		print(string.format("%s Init_IMPMaxStat", Mod.ErrorStr))
--	end

	-- set enemy squad size multiplier
	if not pcall(Init_EnemySquadSizeMultiplier) then
		print(string.format("%s Init_EnemySquadSizeMultiplier", Mod.ErrorStr))
	end

--	-- disable MinFreeMove perk on NPCs
--	if not pcall(Init_DisableMinFreeMovePerkOnNPCs) then
--		print(string.format("%s Init_DisableMinFreeMovePerkOnNPCs", Mod.ErrorStr))
--	end

--	-- disable some mercenaries being randomly offline on new game
--	if not pcall(Init_DisableNewGameOfflineMercs) then
--		print(string.format("%s Init_DisableNewGameOfflineMercs", Mod.ErrorStr))
--	end

	-- set # max militia per sector
	if not pcall(Init_SatelliteSectorMaxMilitia) then
		print(string.format("%s Init_SatelliteSectorMaxMilitia", Mod.ErrorStr))
	end

--	-- enable show chance to hit
--	if not pcall(Init_EnableShowChanceToHit) then
--		print(string.format("%s Init_EnableShowChanceToHit", Mod.ErrorStr))
--	end

	-- set merc inventory size mode
	if not pcall(Init_MercInventorySizeMode) then
		print(string.format("%s Init_MercInventorySizeMode", Mod.ErrorStr))
	end
end

-- when all enabled mods are loaded, the game will issue a lua reload
-- this event is called after the lua reload completes
function OnMsg.Autorun()
	--print("Autorun")
	-- set this flag so that we know when OptionsApply (etc.) is being called on mod load vs. during play
	ModIsBeingLoaded = false
end

function OnMsg.ApplyModOptions(id)
	--print(string.format("ApplyModOptions: %s", id))

	if id == CurrentModId then
		-- only when OptionsApply was triggered by player making changes to settings
--		if ModIsBeingLoaded == false then
--			-- reload mods to trigger ReloadLua() [BLACKLISTED function]
--			-- this regenerates all g_Classes etc.
--			-- BUG: will be called when mod options are changed, without clicking apply.
--			--      the mod option ui is bugged and clicking back will store the new values
--			--      in memory. it will not persist on the next game (exe) start.
--			-- local hash = table.hash(table_kvmap(CurrentModOptions.__defaults, function(k, v) return CurrentModOptions[k] end))
--			-- if hash ~= Temp.prev_CurrentModOptions_hash and Temp.prev_CurrentModOptions_hash ~= nil then
--			-- 	Utils.ModsReloadItems()
--
--			-- 	-- hash the mod options to later tell if they have changed
--			-- 	--Temp.prev_CurrentModOptions_hash = hash
--			-- end
--
--			-- replacing hash as a temp solution in 1.3
--			local dlgParam = GetDialogModeParam((GetDialog("InGameMenu") or GetDialog("PreGameMenu")).idSubContent)
--			if dlgParam and dlgParam.optObj and dlgParam.optObj.id == "ModOptions" then
--				ModOptionsWereApplied = true
--			end
--			-- hash the mod options to later tell if they have changed
--			-- Temp.prev_CurrentModOptions_hash = table.hash(table_kvmap(CurrentModOptions.__defaults, function(k, v) return CurrentModOptions[k] end))
--		end

		--print(string.format("Loading stuff depending on mod options"))

		-- called from root-scope for earliest initialization possible
		Initialize_Early()

		-- on lua reload all class definitions are reset (g_Classes)
		-- many changes are only possible after this fact
		Initialize()

--		UIMods.SetupUIModifications()
	end
end

-- reload mods/lua when mod settings are changed in the options menu
-- msg sent after mod settings are changed (any mod)
function OnMsg.OptionsApply()
	--print("Options apply")

	if ModOptionsWereApplied == true then
		Utils.ModsReloadItems()
	end
end

-- after loading a savegame (session) for the current map
--function OnMsg.LoadSessionData()
--	-- reset I.M.P. mercenary survey
--	Run_UnlockIMP()
--end

---- after hiring a mercenary
--function OnMsg.MercHired(mercId, price, days, alreadyHired)
--	-- reset I.M.P. mercenary survey
--	local unitDef = Presets.UnitDataCompositeDef.IMP[mercId]
--	if unitDef then
--		Run_UnlockIMP()
--	end
--end


function OnMsg.ModsReloaded()
	Utils.ModsReloadItems()
end

---- on visually entering a map
--function OnMsg.OnEnterMapVisual()
--	-- enable show chance to hit
--	Run_EnableShowChanceToHit()
--end

-- trying to fix for 1.4
function OnMsg.DataLoaded()
	Initialize_Early()
	Initialize()
	Utils.ModsReloadItems()
end