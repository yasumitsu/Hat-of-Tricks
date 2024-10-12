-- code from SAD

MapVar("ControlGroups", false)

function SaveControlGroup(name)
	local group = next(Selection) and table.icopy(Selection) or nil
	ControlGroups = ControlGroups or {}
	ControlGroups[name] = group
end

function SelectControlGroup(name)
	local group = GetControlGroup(name)
	table.validate(group)
	if next(group) then
		SelectionSet(group)
	end
end

function ControlGroupSelected(name)
	local group = GetControlGroup(name)
	return next(group) and table.iequal(group, Selection)
end

function GetControlGroup(name)
	return ControlGroups and ControlGroups[name]
end

local function dfs(root, filter)
	if filter(root) then
		return root
	end
	for i,child in ipairs(root) do
		local result = dfs(child, filter)
		if result then return result end
	end
end

function ViewControlGroup(name)
	if not InfopanelContext then return end

	if InfopanelContext == MultiSelectAdapter and g_CurrentSelectionBin then
		local bin_items = InfopanelContext:GetListItems()
		local bin_item_to_view = bin_items[g_CurrentSelectionBin.bin]
		local bin_selection_index = 1
		local items_count = #bin_item_to_view
		if SelectedObj then
			bin_selection_index = table.find(bin_item_to_view, SelectedObj) or items_count
		end
		if (items_count > 1 or SelectedObj) and bin_selection_index + 1 > items_count then
			-- select the next bin or the first if the current is the last
			local current_bin_idx = table.find(bin_items, bin_item_to_view)
			local new_bin_idx = current_bin_idx + 1
			bin_item_to_view = bin_items[new_bin_idx]
			if not bin_item_to_view then
				new_bin_idx = 1
				bin_item_to_view = bin_items[new_bin_idx]
			end
			local template = dfs(XTemplates.tabOverview_Multiselection, function(item) return item.__class == "XContentTemplateList" end)
			local window = dfs(GetDialog("Infopanel"), function(win) return win.xtemplate == template end)
			if window and window.window_state ~= "destroying" then
				window:SetSelection(new_bin_idx)
			end
		end
		InfopanelContext:Locate(bin_item_to_view)
	else
		ViewAndHighlightObject(InfopanelContext)
	end
end

function OnMsg.LoadGame()
	DelayedCall(0, ReloadShortcuts)
end