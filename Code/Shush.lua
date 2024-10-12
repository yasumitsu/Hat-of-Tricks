function OnMsg.DataLoaded()

	if CurrentModOptions["Shush"] == true then
		ForEachPreset("VoiceResponseType", function()
			local type = VoiceResponseTypes
			local shush = {
				type.Order, type.GroupOrder, type.Selection, type.SelectionStealth,
				type.CombatMovementStealth, type.CombatMovement, type.BecomeHidden
			}
			for _, v in ipairs(shush) do
				v.Cooldown = 600000
				v.PerLineCooldown = 1800000
				v.ChanceToPlay = 10
				v.OncePerTurn = true
			end
	
		end)
	end

end