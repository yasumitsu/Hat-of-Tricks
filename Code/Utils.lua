-- shared
CustomSettingsMod = rawget(_G, "CustomSettingsMod") or {}
CustomSettingsMod.Utils = CustomSettingsMod.Utils or {}
local Mod = CustomSettingsMod
local Utils = Mod.Utils

-- create a new table with only the keys in args
function Utils.table_copy_some_keys(tbl, ...)
	local result = {}
	for _, k in ipairs(table.pack(...)) do
		result[k] = tbl[k]
	end

	return result
end

-- table.map but func is called with both key and value 
function Utils.table_kvmap(t, f)
	local new = {}
	for k, v in pairs(t) do
		new[k] = f(k, v)
	end
	return new
end

-- table.map but freely assign both key and value
function Utils.table_kvmap_adv(t, f_k, f_v)
    local new = {}
    local f_k_isFunc = (type(f_k) == "function")
    local f_v_isFunc = (type(f_v) == "function")

    local i = 1
    for k, v in pairs(t) do
        local _k = f_k_isFunc and f_k(k, v, i) or v[f_k]
        local _v = (f_v_isFunc and f_v(k, v, i)) or v[f_v]
        new[_k] = _v
        i = i + 1
    end
    return new
end

-- create a new table from multiple tables or values in args
function Utils.make_table(...)
	local result = {}
	for _, v in ipairs(table.pack(...)) do
		if type(v) == "table" then
			for _, v2 in ipairs(v) do
				result[#result + 1] = v2   
			end
		else
			result[#result + 1] = v
		end
	end

	return result
end

-- round a number to the nearest integer
function Utils.round(num, decimal_places, round_half_up)
	local m = 10 ^ (decimal_places or 0)
	return (((round_half_up and -1 or 1) * num) >= 0) and (-(-(m * num - 0.5) // 1) / m) or (((m * num + 0.5) // 1) / m)
end

function Utils.ceil(n)
    return -(-n // 1)
end

function Utils.floor(n)
	return n // 1
end

-- convert opt_value to a number, return default_value if conversion is not possible
-- (i.e. for opt_values like "Default (x)")
function Utils.ToNumberOrDefault(opt_value, default_value)
	local value = tonumber(opt_value)
	if value == nil then
		return default_value
	else
		return value
	end
end

-- check if the current value of a mod option equals the default value by using the OptionsLookup table
function Utils.IsOptionDefaultValue(option_id)
	local l = Mod.OptionsLookup[option_id]
	local v = l.transform_func and l.transform_func(CurrentModOptions[option_id]) or CurrentModOptions[option_id]
	return Utils.ToNumberOrDefault(v, l.default) == Mod.OptionsLookup[option_id].default
end

-- get a global variable by path (separated by .)
function Utils.GetGlobalByPath(path)
	local var = _G
	for k in path:gmatch("([^.]+)") do
		var = var[k]
	end

	return var
end

-- set a global variable by path (separated by .)
function Utils.SetGlobalByPath(path, value)
	local var_prev = nil
	local key = nil
	local var = _G
	for k in path:gmatch("([^.]+)") do
		var_prev = var
		var = var[k]
		key = k
	end

	var_prev[key] = value
end

-- finds sub-elements in an XTemplate by matching on property name/value
-- multi = nil (first)
-- multi = "first_on_branch" (first on each branch)
-- multi = "all" (all in tree)
-- returns:
-- {
--     {
--         ["element"] = <match_element>,
--         ["ancestors"] = { <ancestor_1>, ... },
--         ["indices"] = { <match_element_index_in_ancestor_1>, ... }
--     },
--     <match_2>,
--     ...
-- }
function Utils.XTemplate_FindElementsByProp(curr, prop, value, multi, ancestors, indices)
	local results = {}

	if type(curr) ~= "table" then
		return false
	end

	if curr[prop] and curr[prop] == value then
		local r = { ["element"] = curr, ["ancestors"] = ancestors, ["indices"] = indices }
		if multi == "all" then
			results = { r }
		else
			return multi == "first_on_branch" and { r } or r
		end
	end

	if curr[1] then
		local new_ancestors = Utils.make_table({ curr }, ancestors and ancestors or nil)
		for i, v in ipairs(curr) do
			local new_indices = Utils.make_table({ i }, indices and indices or nil)
			local result = Utils.XTemplate_FindElementsByProp(v, prop, value, multi, new_ancestors, new_indices)
			if result ~= false then
				if multi then
					for i, r in ipairs(result) do
						table.insert(results, r)
					end
				else
					return result
				end
			end
		end
	end

	return multi and #results > 0 and results or false
end

function Utils.ModsReloadItems()
	CreateRealTimeThread(function()
		ProtectedModsReloadItems(nil, "force_reload")
	end)
end