-- shared
CustomSettingsMod = rawget(_G, "CustomSettingsMod") or {}
CustomSettingsMod.AdvancedSettings = CustomSettingsMod.AdvancedSettings or {}
local Mod = CustomSettingsMod
local Utils = Mod.Utils
local AdvancedSettings = CustomSettingsMod.AdvancedSettings

-- store data
CurrentModStorageTable.AdvancedSettings = CurrentModStorageTable.AdvancedSettings or {}
local Database = CurrentModStorageTable.AdvancedSettings

-- alias in local scope
local GetGlobalByPath = Utils.GetGlobalByPath
local SetGlobalByPath = Utils.SetGlobalByPath

-- values that can be set
AdvancedSettings.Options = {
	["Action Point Costs.Climb1"] = { ["id"] = 1 }, -- default: 1500
	["Action Point Costs.Climb2"] = { ["id"] = 2 }, -- default: 3000
	["Action Point Costs.Climb3"] = { ["id"] = 3 }, -- default: 4000
	["Action Point Costs.Climb4"] = { ["id"] = 4 }, -- default: 4000
	["Action Point Costs.CrouchModifier"] = { ["id"] = 5 }, -- default: 50
	["Action Point Costs.CustomInteractableInteractionCost"] = { ["id"] = 6 }, -- default: 4000
	["Action Point Costs.DifficultTerrainModifier"] = { ["id"] = 7 }, -- default: 50
	["Action Point Costs.Drop1"] = { ["id"] = 8 }, -- default: 1500
	["Action Point Costs.Drop2"] = { ["id"] = 9 }, -- default: 2000
	["Action Point Costs.Drop3"] = { ["id"] = 10 }, -- default: 3000
	["Action Point Costs.Drop4"] = { ["id"] = 11 }, -- default: 3000
	["Action Point Costs.EquipItem"] = { ["id"] = 12 }, -- default: 3000
	["Action Point Costs.ExplorationActionMovesModifierStrong"] = { ["id"] = 13 }, -- default: 12
	["Action Point Costs.ExplorationActionMovesModifierWeak"] = { ["id"] = 14 }, -- default: 4
	["Action Point Costs.GiveItem"] = { ["id"] = 15 }, -- default: 2000
	["Action Point Costs.Interact"] = { ["id"] = 16 }, -- default: 2000
	["Action Point Costs.JumpAcross1"] = { ["id"] = 17 }, -- default: 3000
	["Action Point Costs.JumpAcross2"] = { ["id"] = 18 }, -- default: 4000
	["Action Point Costs.JumpOver1"] = { ["id"] = 19 }, -- default: 2000
	["Action Point Costs.JumpOver2"] = { ["id"] = 20 }, -- default: 3000
	["Action Point Costs.LadderStep"] = { ["id"] = 21 }, -- default: 500
	["Action Point Costs.PickItem"] = { ["id"] = 22 }, -- default: 1000
	["Action Point Costs.ProneModifier"] = { ["id"] = 23 }, -- default: 100
	["Action Point Costs.StairsModifier"] = { ["id"] = 24 }, -- default: 20
	["Action Point Costs.UnloadAmmo"] = { ["id"] = 25 }, -- default: 0
	["Action Point Costs.Walk"] = { ["id"] = 26 }, -- default: 1000
	["Action Point Costs.WaterMoveSpeedModifier"] = { ["id"] = 27 }, -- default: -25
	["AIMGoldCost"] = { ["id"] = 28 }, -- default: 20000
	["BanterBetweenLineTime"] = { ["id"] = 29 }, -- default: 500
	["BoredBanterCD"] = { ["id"] = 30 }, -- default: 4
	["BoredBanterMinHiredSince"] = { ["id"] = 31 }, -- default: 4
	["Combat.ActionCameraHoldTime"] = { ["id"] = 32 }, -- default: 200
	["Combat.AimCritBonus"] = { ["id"] = 33 }, -- default: 0
	["Combat.ArmorDegradePercent"] = { ["id"] = 34 }, -- default: 50
	["Combat.AutofireAttribBonus"] = { ["id"] = 35 }, -- default: 0
	["Combat.AwareSightRange"] = { ["id"] = 36 }, -- default: 24
	["Combat.BombardSetupHoldTime"] = { ["id"] = 37 }, -- default: 1000
	["Combat.BuckshotAttribBonus"] = { ["id"] = 38 }, -- default: 50
	["Combat.BulletDelay"] = { ["id"] = 39 }, -- default: 40
	["Combat.BulletVelocity"] = { ["id"] = 40 }, -- default: 40000
	["Combat.CamoAimPenalty"] = { ["id"] = 41 }, -- default: 50
	["Combat.CamoSightPenalty"] = { ["id"] = 42 }, -- default: 25
	["Combat.ChargeMinAngle"] = { ["id"] = 43 }, -- default: 9000
	["Combat.ChargeMinDistance"] = { ["id"] = 44 }, -- default: 2400
	["Combat.CombatPathTurnsAhead"] = { ["id"] = 45 }, -- default: 0
	["Combat.ConditionPenaltyNeedsRepair"] = { ["id"] = 46 }, -- default: 10
	["Combat.ConditionPenaltyPoor"] = { ["id"] = 47 }, -- default: 20
	["Combat.ConsecutiveShootDelay"] = { ["id"] = 48 }, -- default: 100
	["Combat.ConsecutiveShootDelayAfterAim"] = { ["id"] = 49 }, -- default: 100
	["Combat.DeathExplosion_AnimationDelay"] = { ["id"] = 50 }, -- default: 150
	["Combat.DeathNoiseRange"] = { ["id"] = 51 }, -- default: 8
	["Combat.DodgeMaxDist"] = { ["id"] = 52 }, -- default: 4000
	["Combat.EnemyVrGlobalCd"] = { ["id"] = 53 }, -- default: 10000
	["Combat.ExplosionCrouchDamageMod"] = { ["id"] = 54 }, -- default: -30
	["Combat.ExplosionProneDamageMod"] = { ["id"] = 55 }, -- default: -60
	["Combat.GloryKillChance"] = { ["id"] = 56 }, -- default: 10
	["Combat.Gravity"] = { ["id"] = 57 }, -- default: 9807
	["Combat.GrazingChanceInCover"] = { ["id"] = 58 }, -- default: 40
	["Combat.GrazingHitDamage"] = { ["id"] = 59 }, -- default: 33
	["Combat.GrenadeLaunchAngle"] = { ["id"] = 60 }, -- default: 1800
	["Combat.GrenadeLaunchAngle_Incline"] = { ["id"] = 61 }, -- default: 3600
	["Combat.GrenadeLaunchAngle_Low"] = { ["id"] = 62 }, -- default: 900
	["Combat.GrenadeMaxRPM"] = { ["id"] = 63 }, -- default: 75
	["Combat.GrenadeMinDamageForFly"] = { ["id"] = 64 }, -- default: 30
	["Combat.GrenadeMinRPM"] = { ["id"] = 65 }, -- default: 25
	["Combat.GrenadeStatBonus"] = { ["id"] = 66 }, -- default: 30
	["Combat.HeadshotStealthKillChanceMod"] = { ["id"] = 67 }, -- default: 10
	["Combat.HealAmountBase"] = { ["id"] = 68 }, -- default: 20
	["Combat.HealthPointsCap"] = { ["id"] = 69 }, -- default: 100
	["Combat.IdleVariantMaxTime"] = { ["id"] = 70 }, -- default: 20000
	["Combat.IdleVariantMinTime"] = { ["id"] = 71 }, -- default: 5000
	["Combat.InteractionMaxHeightDifference"] = { ["id"] = 72 }, -- default: 1000
	["Combat.InterruptMoveTiles"] = { ["id"] = 73 }, -- default: 3
	["Combat.KnifeBounceVelocityLoss"] = { ["id"] = 74 }, -- default: 50
	["Combat.KnifeMaxRPM"] = { ["id"] = 75 }, -- default: 90
	["Combat.KnifeMinRPM"] = { ["id"] = 76 }, -- default: 60
	["Combat.KnifeThrowVelocity"] = { ["id"] = 77 }, -- default: 14000
	["Combat.LeadershipThresholdVR"] = { ["id"] = 78 }, -- default: 50
	["Combat.LieutenantHpMod"] = { ["id"] = 79 }, -- default: 125
	["Combat.MaxGrit"] = { ["id"] = 80 }, -- default: 30
	["Combat.MedsPerUse"] = { ["id"] = 81 }, -- default: 1
	["Combat.MeleeAttackProneMod"] = { ["id"] = 82 }, -- default: 20
	["Combat.MGFreeInterruptAttacks"] = { ["id"] = 83 }, -- default: 1
	["Combat.MortarFallVelocity"] = { ["id"] = 84 }, -- default: 30000
	["Combat.NeutralUnitFearRadius"] = { ["id"] = 85 }, -- default: 5
	["Combat.NeutralUnitRelocateAP"] = { ["id"] = 86 }, -- default: 12000
	["Combat.ObstructedAreaAttackDamageReduction"] = { ["id"] = 87 }, -- default: 30
	["Combat.PainNoiseRange"] = { ["id"] = 88 }, -- default: 6
	["Combat.PainNoiseRangeStealthKill"] = { ["id"] = 89 }, -- default: 3
	["Combat.RepositionAPPercent"] = { ["id"] = 90 }, -- default: 70
	["Combat.RocketVelocity"] = { ["id"] = 91 }, -- default: 20000
	["Combat.SelfBandagePercent"] = { ["id"] = 92 }, -- default: 70
	["Combat.ShootDelay"] = { ["id"] = 93 }, -- default: 1300
	["Combat.ShootDelayAfterAim"] = { ["id"] = 94 }, -- default: 700
	["Combat.ShootDelayAfterAimCinematic"] = { ["id"] = 95 }, -- default: 500
	["Combat.ShootDelayAfterInterrupt"] = { ["id"] = 96 }, -- default: 1000
	["Combat.ShootDelayCinematic"] = { ["id"] = 97 }, -- default: 500
	["Combat.ShootDelayNonAI"] = { ["id"] = 98 }, -- default: 1000
	["Combat.ShootDelayTargetOnScreen"] = { ["id"] = 99 }, -- default: 700
	["Combat.SightModHiddenProne"] = { ["id"] = 100 }, -- default: 10
	["Combat.SightModMaxValue"] = { ["id"] = 101 }, -- default: 120
	["Combat.SightModMinValue"] = { ["id"] = 102 }, -- default: 40
	["Combat.SightModStealthStatDiff"] = { ["id"] = 103 }, -- default: 50
	["Combat.SignatureAbilityRechargeTime"] = { ["id"] = 104 }, -- default: 7200
	["Combat.TimerTurnTime"] = { ["id"] = 105 }, -- default: 10000
	["Combat.UnawareSightRange"] = { ["id"] = 106 }, -- default: 12
	["Combat.UnitDeathKillcamWait"] = { ["id"] = 107 }, -- default: 1000
	["Combat.UnitDeathWait"] = { ["id"] = 108 }, -- default: 0
	["EnvEffects.BrushSightMod"] = { ["id"] = 109 }, -- default: -15
	["EnvEffects.DarknessCTHPenalty"] = { ["id"] = 110 }, -- default: -20
	["EnvEffects.DarknessDetectionRate"] = { ["id"] = 111 }, -- default: -30
	["EnvEffects.DarknessSightMod"] = { ["id"] = 112 }, -- default: -10
	["EnvEffects.DustStormCoverCTHPenalty"] = { ["id"] = 113 }, -- default: -5
	["EnvEffects.DustStormGrazeChance"] = { ["id"] = 114 }, -- default: 25
	["EnvEffects.DustStormMoveCostMod"] = { ["id"] = 115 }, -- default: 30
	["EnvEffects.DustStormSightMod"] = { ["id"] = 116 }, -- default: -10
	["EnvEffects.DustStormUnkownFoeDistance"] = { ["id"] = 117 }, -- default: 9600
	["EnvEffects.FireStormSightMod"] = { ["id"] = 118 }, -- default: -10
	["EnvEffects.FogGrazeChance"] = { ["id"] = 119 }, -- default: 25
	["EnvEffects.FogSightMod"] = { ["id"] = 120 }, -- default: -30
	["EnvEffects.FogUnkownFoeDistance"] = { ["id"] = 121 }, -- default: 9600
	["EnvEffects.RainAimingMultiplier"] = { ["id"] = 122 }, -- default: 100
	["EnvEffects.RainConditionLossMod"] = { ["id"] = 123 }, -- default: 100
	["EnvEffects.RainJamChanceMod"] = { ["id"] = 124 }, -- default: 100
	["EnvEffects.RainMishapMaxChance"] = { ["id"] = 125 }, -- default: 75
	["EnvEffects.RainMishapMinChance"] = { ["id"] = 126 }, -- default: 3
	["EnvEffects.RainMishapMultiplier"] = { ["id"] = 127 }, -- default: 200
	["EnvEffects.RainNoiseMod"] = { ["id"] = 128 }, -- default: -50
	["EnvEffects.SightHeightDiffMod"] = { ["id"] = 129 }, -- default: -15
	["EnvEffects.SightHeightDiffThreshold"] = { ["id"] = 130 }, -- default: 10
	["GlobalMercBanterCooldown"] = { ["id"] = 131 }, -- default: 3600
	["Loyalty.CitySectorEnemyTakeOverLoyaltyLoss"] = { ["id"] = 132 }, -- default: -5
	["Loyalty.CivilianDeathPenalty"] = { ["id"] = 133 }, -- default: 5
	["Loyalty.CivilianDeathPenaltyCityCap"] = { ["id"] = 134 }, -- default: 30
	["Loyalty.ConflictDefeatedLoyaltyLoss"] = { ["id"] = 135 }, -- default: -5
	["Loyalty.ConflictMilitiaOnlyWinBonus"] = { ["id"] = 136 }, -- default: 5
	["Loyalty.ConflictRetreatPenalty"] = { ["id"] = 137 }, -- default: -15
	["Loyalty.ConflictWinBonus"] = { ["id"] = 138 }, -- default: 5
	["Satellite.MercArrivalTime"] = { ["id"] = 139 }, -- default: 129600
	["Satellite.MilitiaTrainingThreshold"] = { ["id"] = 140 }, -- default: 3500
	["Satellite.MilitiaUnitsPerTraining"] = { ["id"] = 141 }, -- default: 4
	["StatGaining.BonusToRoll"] = { ["id"] = 142 }, -- default: 30
	["StatGaining.MilestoneAfterMax"] = { ["id"] = 143 }, -- default: 2000
	["StatGaining.MilestoneAfterMaxIncrement"] = { ["id"] = 144 }, -- default: 100
	["StatGaining.PerStatCDMax"] = { ["id"] = 145 }, -- default: 216000
	["StatGaining.PerStatCDMin"] = { ["id"] = 146 }, -- default: 86400
	["StatGaining.PointsPerLevel"] = { ["id"] = 147 }, -- default: 5
	["UnitMoveSpeed.MercCrouchStance"] = { ["id"] = 148 }, -- default: 2400
	["UnitMoveSpeed.MercProneStance"] = { ["id"] = 149 }, -- default: 800
	["UnitMoveSpeed.MercStandingStance"] = { ["id"] = 150 }, -- default: 4800
	["Weapons.BurstDamageBonus"] = { ["id"] = 151 }, -- default: 50
	["Weapons.BurstFireConeWidthMod"] = { ["id"] = 152 }, -- default: 33
	["Weapons.CriticalDamage"] = { ["id"] = 153 }, -- default: 50
	["Weapons.DegradePerShot"] = { ["id"] = 154 }, -- default: 1
	["Weapons.DegradePerShot_GrenadeLauncher"] = { ["id"] = 155 }, -- default: 8
	["Weapons.DegradePerShot_Mortar"] = { ["id"] = 156 }, -- default: 15
	["Weapons.DegradePerShot_RocketLauncher"] = { ["id"] = 157 }, -- default: 15
	["Weapons.DoubleBarrelDamageBonus"] = { ["id"] = 158 }, -- default: 50
	["Weapons.ItemConditionBroken"] = { ["id"] = 159 }, -- default: 0
	["Weapons.ItemConditionExcellent"] = { ["id"] = 160 }, -- default: 95
	["Weapons.ItemConditionNeedsRepair"] = { ["id"] = 161 }, -- default: 40
	["Weapons.ItemConditionPoor"] = { ["id"] = 162 }, -- default: 1
	["Weapons.ItemConditionUsed"] = { ["id"] = 163 }, -- default: 70
	["Weapons.ItemDegradationCounter"] = { ["id"] = 164 }, -- default: 5
	["Weapons.JamConditionLossDivisor"] = { ["id"] = 165 }, -- default: 3
	["Weapons.JamConditionLossMax"] = { ["id"] = 166 }, -- default: 16
	["Weapons.JamConditionLossMin"] = { ["id"] = 167 }, -- default: 3
	["Weapons.JamFixNumSafeAttacks"] = { ["id"] = 168 }, -- default: 2
	["Weapons.LootConditionRandomization"] = { ["id"] = 169 }, -- default: 30
	["Weapons.OvershootMaxDist"] = { ["id"] = 170 }, -- default: 1400
	["Weapons.OvershootMinDist"] = { ["id"] = 171 }, -- default: 900
	["Weapons.PointBlankRange"] = { ["id"] = 172 }, -- default: 4
	["Weapons.ShotgunCollateralDamage"] = { ["id"] = 173 }, -- default: 50
	["Weapons.UpgradeScrapParts"] = { ["id"] = 174 }, -- default: 2
	["XPQuestReward_Large"] = { ["id"] = 175 }, -- default: 1000
	["XPQuestReward_Medium"] = { ["id"] = 176 }, -- default: 500
	["XPQuestReward_Minor"] = { ["id"] = 177 }, -- default: 150
	["XPQuestReward_Small"] = { ["id"] = 178 }, -- default: 300
}
AdvancedSettings.OptionKeys = {}
AdvancedSettings.OptionIds = {}

-- setup options tables
for k, v in pairs(AdvancedSettings.Options) do
	v.default = GetGlobalByPath("const." .. k)

	table.insert(AdvancedSettings.OptionKeys, k)
	AdvancedSettings.OptionIds[v.id] = k
end
table.sort(AdvancedSettings.OptionKeys)

local function Initialize()
	-- set all const values
	for id, v in pairs(Database) do
		local k = AdvancedSettings.OptionIds[id]
		SetGlobalByPath("const." .. k, v)
	end
end

Initialize()

if FirstLoad then
	PlaceObj("TextStyle", {
		DarkMode = "CustomSettings_ConsoleFont_DarkMode",
		TextFont = T(121437438175, "Inconsolata, 14, mono"),
		group = "Common",
		id = "CustomSettings_ConsoleFont",
		save_in = "Common"
	})
	PlaceObj("TextStyle", {
		DisabledRolloverTextColor = -8026488,
		DisabledTextColor = -8026488,
		RolloverTextColor = -5066062,
		ShadowColor = 1073741824,
		ShadowSize = 2,
		TextColor = -5066062,
		TextFont = T(188380725313, "Inconsolata, 14, mono"),
		group = "Common",
		id = "CustomSettings_ConsoleFont_DarkMode",
		save_in = "Common"
	})
end

-- open advanced settings editor
function AdvancedSettings.Open()
	local id = "CustomSettingsAdvanced"

	if not GetDialog(id) then
		OpenDialog(id)
	end
	local dialog = GetDialog(id)
	dialog.ZOrder = 20000000

	dialog.idSettingsText:SetText(AdvancedSettings.GetSettingsStr())
end

-- get the advanced settings as a string
function AdvancedSettings.GetSettingsStr(defaults)
	local str = ""
	for _, k in ipairs(AdvancedSettings.OptionKeys) do
		local v = AdvancedSettings.Options[k]
		str = str .. string.format("%s = %s\n", k, (defaults == nil) and Database[v.id] or v.default)
	end

	return str
end

-- save the advanced settings parsed from a string
function AdvancedSettings.SaveSettingsStr(str)
	local n = 0
	for line in str:gmatch("([^\r\n]+)") do
		local key, value = string.match(line, "%s*(.-)%s*=%s*(.+)%s*")
		value = tonumber(value)
		if key ~= nil and value ~= nil and AdvancedSettings.Options[key] ~= nil then
			Database[AdvancedSettings.Options[key].id] = (value ~= AdvancedSettings.Options[key].default) and value or nil
			
			n = n + 1
		end
	end

	if n > 0 then
		WriteModPersistentStorageTable()

		Utils.ModsReloadItems()
	end
end

---- global
OpenAdvancedSettings = AdvancedSettings.Open
GetAdvancedSettingsStr = AdvancedSettings.GetSettingsStr
SaveAdvancedSettingsStr = AdvancedSettings.SaveSettingsStr