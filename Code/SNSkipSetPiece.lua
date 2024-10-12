function SNSkipSetPiece()
	local campaign = Game and Game.Campaign or rawget(_G, "DefaultCampaign") or "HotDiamonds"
	local campaign_presets = rawget(_G, "CampaignPresets") or empty_table
	local sectors = campaign_presets[campaign] and campaign_presets[campaign].Sectors or empty_table
	local map_to_sector = {[false] = ""}
	for _, sector in ipairs(sectors) do
		if sector.Map then
			if sector.awareness_sequence ~= "Skip Setpiece" then
				sector.awareness_sequence = "Skip Setpiece"
			end
		end
	end
end

function OnMsg.DataLoaded()
	if CurrentModOptions["SNSkipSetPiece"] == true then
		SNSkipSetPiece()
	end
end





--function OnMsg.PreLoadSessionData()
--    for _, mod in ipairs(ModsLoaded) do
--        mod:ForEachModItem("ModItemSector", function(item)
--            local id = item.sectorId
--            local sector = item.SatelliteSectorObj
--            if id and sector and gv_Sectors[id] then
--                gv_Sectors[id].template_key = "Sectors"
--                CampaignObject.SetId(gv_Sectors[id], id)
--            end
--        end)
--    end
--end 