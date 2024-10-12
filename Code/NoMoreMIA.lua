if CurrentModOptions["NoMoreMIA"] == true then
	function OnMsg.NewDay()
		local time = GetTimeAsTable(Game.CampaignTime)
		local day = time.day
		if day ~= 1 then return end -- New month started
		
		local monthsPassed = GetMonthsPassed(Game.CampaignTimeStart, Game.CampaignTime) -- the starting day is ignored
		for i, monthRange in ipairs(gv_RandomMonthsRolled) do
			if monthsPassed == monthRange then
				local mercsEligible = {}
				ForEachMerc(function(mId)
					local ud = gv_UnitData[mId]
					if ud and ud.HireStatus == "MIA" then
						ud.HireStatus = "Available"
					end
				end)
			end
		end
	end
end
