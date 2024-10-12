-- shared
CustomSettingsMod = rawget(_G, "CustomSettingsMod") or empty_table
CustomSettingsMod.UIMods = CustomSettingsMod.UIMods or empty_table
CustomSettingsMod.UIMods.Applied = CustomSettingsMod.UIMods.Applied or empty_table
local Mod = CustomSettingsMod
local Utils = Mod.Utils
local UIMods = Mod.UIMods

-- alias in local scope
local make_table = Utils.make_table
local FindElement = Utils.XTemplate_FindElementsByProp
local IsOptionDefaultValue = Utils.IsOptionDefaultValue

-- forward declarations
local DisableModOptionsConditionally

function OnMsg.DataLoaded()

	--if FirstLoad then
		-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		-- Add sub-category headers to mod settings (only applies to this mod)
		-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
		-- decrease separator height if it is a sub-category
		local x_oe_pc = FindElement(XTemplates["OptionsEntry"], "__class", "XPropControl")
		x_oe_pc.element.OnContextUpdate = function(self, context, ...)
			if context.prop_meta.subcategory then
				self.MinHeight = 48
				self.MaxHeight = 48
			end
		end
	
		--idOptionsListCont
		local x_mm_os = FindElement(XTemplates["MainMenu"], "Id", "idOptionsListCont")
	
		--XTemplateForEach (properties)
		local x_mm_os_e = FindElement(x_mm_os.element, "comment", "properties")
	
		-- insert sub-category separators into built properties array
		local x_mm_os_e_array_old = x_mm_os_e.element.array
		x_mm_os_e.element.array = function(parent, context)
			local result = x_mm_os_e_array_old(parent, context)
			local arr = {}
	
			local param = GetDialogModeParam(parent)
			if param and param.optObj.id == "ModOptions" then
				local options = CustomSettingsMod.ModDef:GetOptionItems()
				local prevSubCategory = nil
				for _, prop in ipairs(result) do
					if prop.modId == CustomSettingsMod.ModId then
						local item = table.find_value(options, "name", prop.id)
						if item then
							prop.enabled_if = item.enabled_if
	
							if (item.SubCategory ~= nil) and (item.SubCategory ~= prevSubCategory) then
								table.insert(arr, {
									separator = "<style OptionsActionButton>" .. item.SubCategory .. "</style>",
									category = "Mod",
									subcategory = true
								})
							end
	
							prevSubCategory = item.SubCategory
						end
					end
	
					table.insert(arr, prop)
				end
			end
	
			return (#arr > 0) and arr or result
		end
	
	
		-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		-- Disable mod options conditionally based on the values of other mod options
		-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
		--idSubContent
		local x_mm_sc = FindElement(XTemplates["MainMenu"], "Id", "idSubContent")
	
		--XTemplateFunc: OnDialogModeChange
		local x_mm_sc_func = FindElement(x_mm_sc.element, "name", "OnDialogModeChange(self, mode, dialog)")
	
		-- hook OnDialogModeChange for initialization
		local x_mm_sc_func_old = x_mm_sc_func.element.func
		
		local x_mm_sc_func_new = function(self, mode, dialog)
			x_mm_sc_func_old(self, mode, dialog)
	
			if mode == "options" then
				DisableModOptionsConditionally()
			end
		end
	
		x_mm_sc_func.element.func = x_mm_sc_func_new
	
		-- hook OnDialogModeChange for initialization (on PreGameMenu which is spawned before we have a chance to modify the template)
		--GetDialog("PreGameMenu").idSubContent.OnDialogModeChange = x_mm_sc_func_new
	
	
		-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		-- Add hotkey to open mod menu
		-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		table.insert(XTemplates.GameShortcuts, PlaceObj('XTemplateAction', {
			'ActionId', "CustomSettings_actionIdToggleModMenu",
			'ActionSortKey', "9000",
			'ActionName', "Toggle Custom Settings Mod Menu",
			'ActionDescription', "",
			'ActionShortcut', "Ctrl-Alt-S",
			'ActionBindable', true,
			'OnAction', function(self, host, source, ...)
				if not IsEditorActive() and not Platform.ged then
					CustomSettingsMenuTarget:Toggle()
				end
			end,
			'IgnoreRepeated', true,
			'replace_matching_id', true,
		}))
	
	
		-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		-- Add Mod Menu shortcut to in-game "COMMAND" menus
		-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
		for _, v in ipairs(FindElement(XTemplates["StartButtonContextMenu"], "OnPressParam", "OpenHelp", "first_on_branch")) do
			-- insert separator after "Help" entry
			table.insert(v.ancestors[1], v.indices[1] + 1, PlaceObj("XTemplateWindow", {
				"__class",
				"XFrame",
				"Margins",
				box(18, 5, 18, 6),
				"Image",
				"UI/PDA/separate_line_vertical",
				"FrameBox",
				box(5, 0, 5, 0),
				"SqueezeY",
				false
			}, {
				PlaceObj("XTemplateFunc", {
				"name",
				"IsSelectable()",
				"func",
				function()
					return false
				end
				})
			})
			)
		
			-- insert mod menu shortcut
			table.insert(v.ancestors[1], v.indices[1] + 2, PlaceObj("XTemplateTemplate", {
				"__template",
				"ContextMenuButton",
				"MinHeight",
				28,
				"MaxHeight",
				28,
				"MouseCursor",
				"UI/Cursors/Pda_Hand.tga",
				"OnPress",
				function(self, gamepad)
					CustomSettingsMenuTarget:Toggle()
				end,
				"Text",
				"Mod Menu (CS)"
			})
			)
		end
	--end
end


-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Disable mod options conditionally based on the values of other mod options
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

DisableModOptionsConditionally = function()
	local dlg = GetDialog("InGameMenu") or GetDialog("PreGameMenu")
	local menu = dlg and dlg.idSubMenu
	local scroll_a = menu and menu.idScrollArea
	if not scroll_a then
		return
	end

	local param = GetDialogModeParam(menu)
	if not param or param.optObj.id ~= "ModOptions" then
		return
	end

	local options = CustomSettingsMod.ModDef.options

	-- check enable_if for other options in this mod
	for i, v in ipairs(scroll_a) do
		if v.prop_meta and v.prop_meta.id and v.prop_meta.modId == CustomSettingsMod.ModId and type(v.prop_meta.enabled_if) == "function" then
			local enabled = v.prop_meta.enabled_if(options)
			if v.prop_meta.editor == "choice" then
				if enabled == true then
					v.idValue:SetEnabled(true)
					if v.OnMouseButtonDown_old then
						v.OnMouseButtonDown = v.OnMouseButtonDown_old
						v.OnMouseButtonDown_old = nil
					end
				elseif enabled == false then
					v.idValue:SetEnabled(false)
					v.OnMouseButtonDown_old = v.OnMouseButtonDown
					function v.OnMouseButtonDown()
						PlayFX("activityAssignSelectDisabled", "start")
					end
				end
			end
		end
	end
end

function OnMsg.OptionsChanged()
	DisableModOptionsConditionally()
end

function UIMods.SetupUIModifications()
	-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-- Add hotkey to pause the game in tactical view
	-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



	-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-- Modify Squad Management UI to support more than six mercenaries per squad
	-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	if UIMods.Applied["PDASquadManagement"] ~= true and not IsOptionDefaultValue("idCS_MercSquadMaxPeople") then
		-- only modify once
		UIMods.Applied["PDASquadManagement"] = true

		--idContent
		local x_sqm_content = FindElement(XTemplates["PDASquadManagement"], "Id", "idContent")
		--idSquadsList
		local x_sqm = FindElement(XTemplates["PDASquadManagement"], "Id", "idSquadsList")
		-- idMercScroll
		local x_sqm_scroll = FindElement(x_sqm.element, "Id", "idMercScroll")
		-- XTemplateForEach (Player Squads)
		local x_sqm_ps_each = FindElement(x_sqm.element, "comment", "player squad")
		-- XContextWindow (Player Squads Template)
		local x_sqm_ps = x_sqm_ps_each.element[1]
		-- XTemplateTemplate (Mercs Template)
		local x_sqm_merc = FindElement(x_sqm_ps, "__template", "HUDMerc")
		-- XTemplateForEach (Mercs)
		local x_sqm_merc_each = x_sqm_merc.ancestors[1]

		-- show squads that can only partially fit in the current view
		x_sqm.element.ShowPartialItems = true
		-- remove the left margin on the scroll bar to fit 7 tiles horizontally
		x_sqm_scroll.element.Margins = box(0, 0, 0, 0)
		-- wrap to fit mercs on multiple rows if needed
		x_sqm_ps.LayoutMethod = "HWrap"

		-- restore saved scroll offset after a context update
		x_sqm_content.element.OnLayoutComplete = function(self)
			local savedScroll = self.savedScrollValue
			if type(savedScroll) ~= "nil" then
				local newScroll = self.idSquadManage
				newScroll = newScroll and newScroll.idSquadsList
				if newScroll then
					newScroll:ScrollTo(0, savedScroll)
					self.savedScrollValue = nil
				end
			end
		end

		-- save scroll offset on context update
		local x_sqm_content_OnContextUpdate_old = x_sqm_content.element.OnContextUpdate
		x_sqm_content.element.OnContextUpdate = function(self, context, ...)
			-- store value
			local squadList = self.idSquadManage
			squadList = squadList and squadList.idSquadsList
			local scroll = squadList and squadList:GetVScroll()
			scroll = scroll and squadList:ResolveId(scroll)
			local scrollValue = scroll and scroll:GetScroll()
			self.savedScrollValue = scrollValue

			-- call old handler
			x_sqm_content_OnContextUpdate_old(self, context, ...)
		end

		-- change the original map function to return "hide" rather than "empty"
		-- for merc placeholders that we do not want to take up layout space
		x_sqm_merc_each.map = function(parent, context, array, i)
			local w = "empty"
			-- if there is an empty merc placeholder on row 3, then hide row 4 and onwards
			-- (this will not happen as 20 mercs fit on 3 rows (6 + 7 + 7))
			if i > 20 and array[13] == "empty" then
				w = "hide"
			-- if there is an empty merc placeholder on row 2, then hide row 3 and onwards
			elseif i > 13 and array[13] == "empty" then
				w = "hide"
			-- if there is an empty merc placeholder on row 1, then hide row 2 and onwards
			elseif i > 6 and array[6] == "empty" then
				w = "hide"
			end

			return array and gv_UnitData[array[i]] or w
		end

		-- remove the merc placeholders that would otherwise show up as empty rows
		x_sqm_merc_each.condition = function(parent, context, item, i)
			return item ~= "hide"
		end
	end


	-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-- Modify Inventory UI to add toggleable sorting to the sector inventory
	-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--	if UIMods.Applied["Inventory"] ~= true and CurrentModOptions["idCS_InventorySorting"] then
--		-- only modify once
--		UIMods.Applied["Inventory"] = true
--
--		-- idInventory
--		local x_inv = FindElement(XTemplates["Inventory"], "Id", "idInventory")
--
--		-- idScrollAreaCenter
--		local x_inv_sac = FindElement(x_inv.element, "Id", "idScrollAreaCenter")
--
--		-- idInventory.Open(...)
--		local x_inv_open_func = FindElement(x_inv.element, "name", "Open")
--
--		-- idInventory.TakeAllAction(...)
--		local x_inv_takeallaction_func = FindElement(x_inv.element, "name", "TakeAllAction(self)")
--
--		-- idInventory.TakeAll (XTemplateAction)
--		local x_inv_takeallaction = FindElement(x_inv.element, "ActionId", "TakeAll")
--
--		-- idScrollAreaCenter backpack title
--		local x_inv_sac_bpt = FindElement(x_inv_sac.element, "Id", "idName")
--
--		-- sort sector inventory when UI is opened
--		local x_inv_open_func_old = x_inv_open_func.element.func
--		x_inv_open_func.element.func = function(self, ...)
--			local retVal = x_inv_open_func_old(self, ...)
--			CustomSettingsMod.InventorySorting.SortSectorInventory(self, self:GetContext())
--
--			return retVal
--		end

--		-- insert ToggleSortAllAction(...) func
--		table.insert(x_inv_takeallaction_func.ancestors[1], x_inv_takeallaction_func.indices[1] + 1, PlaceObj("XTemplateFunc", {
--			"name",
--			"ToggleSortAllAction(self)",
--			"func",
--			function(self)
--				CustomSettingsMod.InventorySorting.AutoSortEnabled = not CustomSettingsMod.InventorySorting.AutoSortEnabled
--			
--			if CustomSettingsMod.InventorySorting.AutoSortEnabled then
--				CustomSettingsMod.InventorySorting.SortSectorInventory(self, self:GetContext())
--			else
--				-- trigger resetting the sector inventory
--				local sector_id = gv_SectorInventory.sector_id
--				gv_SectorInventory:Clear()
--				gv_SectorInventory:SetSectorId(sector_id)
--				InventoryUIRespawn()
--			end
--			end
--		})
--		)
--
--		-- insert ToggleSortAllState(...) func
--		table.insert(x_inv_takeallaction_func.ancestors[1], x_inv_takeallaction_func.indices[1] + 1, PlaceObj("XTemplateFunc", {
--			"name",
--			"ToggleSortAllState(self)",
--			"func",
--			function(self)
--			local context = self:GetContext()
--			local container = context and context.container
--			if not container then
--				return "hidden"
--			end
--			local containers = InventoryGetLootContainers(container) or empty_table
--			local hasItem = false
--			for _, cont in ipairs(containers) do
--				local container_slot_name = GetContainerInventorySlotName(cont)
--				if cont:GetItemInSlot(container_slot_name) then
--				hasItem = true
--				break
--				end
--			end
--			if not hasItem then
--				return "hidden"
--			end
--			return "enabled"
--			end
--		})
--		)
--
--		-- insert togglesortall button
--		table.insert(x_inv_sac_bpt.ancestors[1], x_inv_sac_bpt.indices[1] + 1, PlaceObj("XTemplateTemplate", {
--			"comment",
--			"togglesortall button",
--			"__condition",
--			function(parent, context)
--			local host = GetActionsHost(parent, true)
--			local context = host:GetContext()
--			return context and IsKindOf(context.container, "SectorStash")
--			end,
--			"__template",
--			"InventoryActionBarButtonCenter",
--			"HAlign",
--			"right",
--			"VAlign",
--			"center",
--			"OnContextUpdate",
--			function(self, context, ...)
--			local host = GetActionsHost(self.parent, true)
--			local hidden = host:ToggleSortAllState() == "hidden"
--			self:SetVisible(not hidden)
--			end,
--			"OnPressEffect",
--			"action",
--			"OnPressParam",
--			"ToggleSortAll"
--		}, {
--			PlaceObj("XTemplateFunc", {
--			"name",
--			"Open",
--			"func",
--			function(self, ...)
--				XTextButton.Open(self)
--				if self.action then
--				if CustomSettingsMod.InventorySorting.AutoSortEnabled then
--					self:SetText(self.action.ActionName .. " (ON)")
--					self.idBtnText:SetTextColor(RGB(0, 255, 0))
--					self.idBtnText:SetRolloverTextColor(RGB(0, 255, 0))
--				else
--					self:SetText(self.action.ActionName .. " (OFF)")
--					self.idBtnText:SetTextColor(RGB(255, 0, 0))
--					self.idBtnText:SetRolloverTextColor(RGB(255, 0, 0))
--				end
--				end
--				local host = GetActionsHost(self.parent, true)
--				local hidden = host:ToggleSortAllState() == "hidden"
--				self:SetVisible(not hidden)
--			end
--			}),
--			PlaceObj("XTemplateFunc", {
--			"name",
--			"Press(self, alt, force, gamepad)",
--			"func",
--			function(self, alt, force, gamepad)
--				XTextButton.Press(self, alt, force, gamepad)
--			end
--			})
--		})
--		)
--
		-- insert ToggleSortAllState(...) func
--		table.insert(x_inv_takeallaction.ancestors[1], x_inv_takeallaction.indices[1] + 1, PlaceObj("XTemplateAction", {
--			"ActionId",
--			"ToggleSortAll",
--			"ActionName",
--			"SORT",
--			"ActionShortcut",
--			"Y",
--			"ActionState",
--			function(self, host)
--			return host:ToggleSortAllState()
--			end,
--			"OnAction",
--			function(self, host, source, ...)
--			return host:ToggleSortAllAction()
--			end
--		})
--		)
	--end
end