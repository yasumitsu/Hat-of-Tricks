-- -- Tutorial Hints
-- GameVar("TutorialHintsState", function() return { visible = {}, mode = {} } end)

-- function OpenHelpMenu(atHint)
	-- local parent = false
	-- local pda = GetDialog("PDADialog")
	-- if pda then
		-- parent = pda.idDisplayPopupHost
	-- end
	-- local popupUI = XTemplateSpawn("PopupNotification", parent, TutorialGetHelpMenuHints())
	-- popupUI:Open()
	-- popupUI.idHintChoices:SetVisible(true)
	-- popupUI.idPopupTitle:SetText(T(174457905586, "HELP TOPICS"))
	-- popupUI:SetSelectedHint(atHint)
-- end

-- function TutorialGetHelpMenuHints()
	-- local state = TutorialHintsState
	-- if not state then return empty_table end
	
	-- local byMode = {}
	-- for hintId, hintPreset in sorted_pairs(TutorialHints) do
		-- local hintVisible = state.visible[hintId]
		-- if not hintVisible then goto continue end
		
		-- if hintPreset.group == "TutorialPopups" then goto continue end
		
		-- local mode = state.mode[hintId] or "visible"
		-- if not byMode[mode] then byMode[mode] = {} end
		
		-- local data = { 
			-- preset = hintPreset,
			-- popupPreset = PopupNotifications[hintPreset.PopupId],
			-- Title = hintPreset.PopupId and PopupNotifications[hintPreset.PopupId].Title or Untranslated("UNTITLED"),
			-- Text = hintPreset.Text,
			-- mode = mode,
			-- id = hintId
		-- }
		-- table.insert(byMode[mode], data)
		-- ::continue::
	-- end
	
	-- -- Sort all modes alphabetically
	-- for i, modeTable in pairs(byMode) do
		-- TSort(modeTable, "Text", true)
	-- end
	
	-- local modeSorted = {}
	-- local dismissed = byMode["dismissed"] or empty_table
	-- local function AddToArray(mode)
		-- local modeArray = byMode[mode] or empty_table
		-- table.iappend(modeSorted, modeArray)
	-- end
	-- AddToArray("dismissed")
	-- AddToArray("completed")
	-- AddToArray("ui-hidden")
	-- AddToArray("visible")
	
	-- return modeSorted
-- end

-- function TutorialIsHintRead(context)
	-- local hintId = context.preset.id
	-- local read = TutorialHintsState.read and TutorialHintsState.read[hintId]
	-- return read
-- end

-- function TutorialGetCurrentHints()
	-- local state = TutorialHintsState
	-- if not state then return empty_table end
	
	-- local tutorialHints = {}
	-- for hintId, hintPreset in sorted_pairs(TutorialHints) do
		-- local hintVisible = state.visible[hintId]
		-- local mode = state.mode[hintId]
		-- if hintVisible and (mode ~= "completed" and mode ~= "ui-hidden" and mode ~= "dismissed") then
			-- tutorialHints[#tutorialHints + 1] = { 
				-- preset = hintPreset,
				-- Title = hintPreset.PopupId and PopupNotifications[hintPreset.PopupId].Title or Untranslated("UNTITLED"),
				-- Text = hintPreset.Text
			-- }
		-- end
	-- end
	-- return tutorialHints
-- end

-- function TutorialDismissHint(hintPreset)
	-- TutorialHintsState.mode[hintPreset.id] = "dismissed"
	-- ObjModified(TutorialHintsState)
-- end

-- function OnMsg.OpenSatelliteView()
	-- TutorialHintVisibilityEvaluate()
-- end

-- -- http://mantis.haemimontgames.com/view.php?id=172918
-- function TutorialHintVisibilityEvaluate()
	-- local state = TutorialHintsState
	-- if not state then return end
	
	-- ForEachPresetInCampaign("TutorialHint", function(note)
		-- local hintId = note.id
 		-- local mode = state.mode[hintId]
		-- if mode == "completed" or mode == "dismissed" then goto continue end

		-- local updated = false
		-- local hide = note.HideConditions and #note.HideConditions > 0 and EvalConditionList(note.HideConditions, note) 
		-- local currentHidden = mode == "ui-hidden"
		-- if hide ~= currentHidden then
			-- state.mode[hintId] = hide and "ui-hidden" or false
			-- updated = true
		-- end
		
		-- if not state.visible[hintId] and EvalConditionList(note.ShowConditions, note) then
			-- state.visible[hintId] = GetQuestNoteCampaignTimestamp()
			-- if g_Combat then TutorialHintsState.IsHintPerTurnPlayed = true end
			-- updated = true
			
			-- if note.PopupId and note.group ~= "StartingHelp" then
				-- CreateRealTimeThread(function()
					-- WaitPlayerControl({ skip_popup = true, no_coop_pause = true })
					-- WaitLoadingScreenClose()
					-- ShowPopupNotification(note.PopupId)
				-- end)
			-- end
		-- end
		
		-- if state.visible[hintId] and EvalConditionList(note.CompletionConditions, note) then
			-- state.mode[hintId] = "completed"
			-- updated = true
		-- end
		
		-- if updated then
			-- DelayedCall(0, ObjModified, TutorialHintsState)
		-- end
		
		-- ::continue::
	-- end)
-- end