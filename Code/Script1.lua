local function ApplyMod()
	local options = CurrentModOptions or {}
		if options.Cheats then
			Platform.cheats = true
		end
		if not options.Cheats then
			Platform.cheats = false
		end
	end
	
	
	OnMsg.ModsReloaded = ApplyMod
	OnMsg.ApplyModOptions = ApplyMod