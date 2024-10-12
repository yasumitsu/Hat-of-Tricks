-- --Prevent Camera Position Change During Battle: Ensure the camera doesn't change position automatically during battles.
-- --Increase Zoom In and Out Range: Extend the range for camera zoom.
-- --Lock/Unlock Camera on First Unit: Add an option to lock and unlock the camera on the first unit of the player's squad.
-- --Track Active Unit: Add an option to track the active unit that the player is aware of.
-- --Shortcut to Return Camera to Active Unit: Implement a shortcut to return the camera to the active unit.



-- --Explanation of Changes
-- --Global Variables: Added to control camera behavior (camera_lock_on_first_unit, camera_track_active_unit, prevent_camera_change).
-- --New Functions:
-- --PreventCameraChangeDuringBattle to control whether the camera position should change.
-- --SetZoomRange to set the zoom in and out range.
-- --LockCameraOnFirstUnit to lock/unlock the camera on the first unit.
-- --TrackActiveUnit to enable/disable tracking of the active unit.
-- --ReturnCameraToActiveUnit to return the camera to the active unit.
-- --Modified Functions:
-- --TrackUnitMovement updated to respect prevent_camera_change.
-- --ControlCameraDuringBattle to handle the camera locking and tracking logic.
-- --Event Hooks: Hooked into game events to apply camera control logic (OnMsg.NewGame, OnMsg.CombatStarted, OnMsg.CombatEnded, OnMsg.UnitMovementDone).
-- --Keybindings: Added keybindings for the new functionality (L, T, R).

-- -- Global variables to control camera behavior
-- local camera_lock_on_first_unit = false
-- local camera_track_active_unit = false
-- local prevent_camera_change = false
-- local first_unit_id = nil

-- -- Function to prevent camera position change during battle
-- function PreventCameraChangeDuringBattle(prevent)
--     prevent_camera_change = prevent
-- end

-- -- Function to increase zoom in and out range
-- function SetZoomRange(min_zoom, max_zoom)
--     cameraMinZoom = min_zoom
--     cameraMaxZoom = max_zoom
-- end

-- -- Function to lock/unlock camera on first unit
-- function LockCameraOnFirstUnit(lock)
--     camera_lock_on_first_unit = lock
--     if lock then
--         first_unit_id = GetPlayerSquadFirstUnitID()
--         if first_unit_id then
--             local unit = GetUnitById(first_unit_id)
--             if unit then
--                 CameraFollowUnit(unit)
--             end
--         end
--     else
--         CameraUnlock()
--     end
-- end

-- -- Function to track active unit
-- function TrackActiveUnit(track)
--     camera_track_active_unit = track
-- end

-- -- Shortcut to return camera to active unit
-- function ReturnCameraToActiveUnit()
--     local active_unit = GetPlayerActiveUnit()
--     if active_unit then
--         CameraFollowUnit(active_unit)
--     end
-- end

-- -- Modify existing functions to include new behavior

-- -- Override function to track unit movement
-- function TrackUnitMovement(unit, args)
--     if prevent_camera_change then
--         return
--     end

--     if unit:IsInCombat() then
--         local group = g_AIExecutionController and g_AIExecutionController.group_to_follow
--         if group then
--             for _, gunit in ipairs(group) do
--                 if gunit == unit then
--                     g_AITurnContours[unit.handle] = SpawnUnitContour(unit, "CombatEnemy")
--                     ShowBadgeOfAttacker(unit, true)
--                     g_AIExecutionController.fallbackMoveTracking = true
--                     args.trackMove = true
--                     break
--                 end
--             end
--         end
--     end

--     if args.trackMove then
--         g_AIExecutionController.tracked_pois = g_AIExecutionController.tracked_pois or {}
--         table.insert(g_AIExecutionController.tracked_pois, unit)
--         return args.fallbackMove, true
--     end
-- end

-- -- Override function to control camera behavior
-- function ControlCameraDuringBattle()
--     if camera_lock_on_first_unit and first_unit_id then
--         local unit = GetUnitById(first_unit_id)
--         if unit then
--             CameraFollowUnit(unit)
--         end
--     elseif camera_track_active_unit then
--         local active_unit = GetPlayerActiveUnit()
--         if active_unit then
--             CameraFollowUnit(active_unit)
--         end
--     end
-- end

-- -- Hook into existing game events to apply camera control
-- function OnMsg.NewGame()
--     SetZoomRange(0.5, 3.0)  -- Example zoom range
-- end

-- function OnMsg.CombatStarted()
--     PreventCameraChangeDuringBattle(true)
-- end

-- function OnMsg.CombatEnded()
--     PreventCameraChangeDuringBattle(false)
-- end

-- function OnMsg.UnitMovementDone(unit, action_id)
--     ControlCameraDuringBattle()
-- end

-- -- Keybindings for new functionality (example keys, customize as needed)
-- function OnMsg.KeyDown(key)
--     if key == "L" then  -- Lock/Unlock camera on first unit
--         LockCameraOnFirstUnit(not camera_lock_on_first_unit)
--     elseif key == "T" then  -- Track active unit
--         TrackActiveUnit(not camera_track_active_unit)
--     elseif key == "R" then  -- Return camera to active unit
--         ReturnCameraToActiveUnit()
--     end
-- end


-- -- Global variables to control camera behavior
-- local prevent_camera_change = false
-- local camera_lock_on_first_unit = false
-- local first_unit_id = nil
-- local camera_track_active_unit = false

-- -- Function to prevent camera position change during battle
-- function PreventCameraChangeDuringBattle(prevent)
--     prevent_camera_change = prevent
-- end

-- -- Function to increase zoom in and out range
-- function SetZoomRange(min_zoom, max_zoom)
--     cameraMinZoom = min_zoom
--     cameraMaxZoom = max_zoom
-- end

-- -- Function to lock/unlock camera on first unit
-- function LockCameraOnFirstUnit(lock)
--     camera_lock_on_first_unit = lock
--     if lock then
--         first_unit_id = GetPlayerSquadFirstUnitID()
--         if first_unit_id then
--             local unit = GetUnitById(first_unit_id)
--             if unit then
--                 CameraFollowUnit(unit)
--             end
--         end
--     else
--         CameraUnlock()
--     end
-- end

-- -- Function to track active unit
-- function TrackActiveUnit(track)
--     camera_track_active_unit = track
-- end

-- -- Function to return camera to active unit
-- function ReturnCameraToActiveUnit()
--     local active_unit = GetPlayerActiveUnit()
--     if active_unit then
--         CameraFollowUnit(active_unit)
--     end
-- end

-- -- Override function to track unit movement
-- function TrackUnitMovement(unit, args)
--     if prevent_camera_change then
--         return
--     end

--     -- Existing functionality
--     if unit:IsInCombat() then
--         local group = g_AIExecutionController and g_AIExecutionController.group_to_follow
--         if group then
--             for _, gunit in ipairs(group) do
--                 if gunit == unit then
--                     g_AITurnContours[unit.handle] = SpawnUnitContour(unit, "CombatEnemy")
--                     ShowBadgeOfAttacker(unit, true)
--                     g_AIExecutionController.fallbackMoveTracking = true
--                     args.trackMove = true
--                     break
--                 end
--             end
--         end
--     end

--     if args.trackMove then
--         g_AIExecutionController.tracked_pois = g_AIExecutionController.tracked_pois or {}
--         table.insert(g_AIExecutionController.tracked_pois, unit)
--         return args.fallbackMove, true
--     end
-- end

-- -- Function to control camera behavior during battle
-- function ControlCameraDuringBattle()
--     if camera_lock_on_first_unit and first_unit_id then
--         local unit = GetUnitById(first_unit_id)
--         if unit then
--             CameraFollowUnit(unit)
--         end
--     elseif camera_track_active_unit then
--         local active_unit = GetPlayerActiveUnit()
--         if active_unit then
--             CameraFollowUnit(active_unit)
--         end
--     end
-- end

-- -- Hook into existing game events to apply camera control
-- function OnMsg.NewGame()
--     SetZoomRange(0.5, 3.0)  -- Example zoom range
-- end

-- function OnMsg.CombatStarted()
--     PreventCameraChangeDuringBattle(true)
-- end

-- function OnMsg.CombatEnded()
--     PreventCameraChangeDuringBattle(false)
-- end

-- function OnMsg.UnitMovementDone(unit, action_id)
--     ControlCameraDuringBattle()
-- end

-- -- Keybindings for new functionality (example keys, customize as needed)
-- function OnMsg.KeyDown(key)
--     if key == "L" then  -- Lock/Unlock camera on first unit
--         LockCameraOnFirstUnit(not camera_lock_on_first_unit)
--     elseif key == "T" then  -- Track active unit
--         TrackActiveUnit(not camera_track_active_unit)
--     elseif key == "R" then  -- Return camera to active unit
--         ReturnCameraToActiveUnit()
--     end
-- end










-- -- Global variables to control camera behavior
-- local prevent_camera_change = false
-- local camera_lock_on_first_unit = false
-- local first_unit_id = nil
-- local camera_track_active_unit = false

-- -- Function to prevent camera position change during battle
-- function PreventCameraChangeDuringBattle(prevent)
--     prevent_camera_change = prevent
-- end

-- -- Function to increase zoom in and out range
-- function SetZoomRange(min_zoom, max_zoom)
--     cameraMinZoom = min_zoom
--     cameraMaxZoom = max_zoom
-- end

-- -- Function to lock/unlock camera on first unit
-- function LockCameraOnFirstUnit(lock)
--     camera_lock_on_first_unit = lock
--     if lock then
--         first_unit_id = GetPlayerSquadFirstUnitID()
--         if first_unit_id then
--             local unit = GetUnitById(first_unit_id)
--             if unit then
--                 CameraFollowUnit(unit)
--             end
--         end
--     else
--         CameraUnlock()
--     end
-- end

-- -- Function to track active unit
-- function TrackActiveUnit(track)
--     camera_track_active_unit = track
-- end

-- -- Function to return camera to active unit
-- function ReturnCameraToActiveUnit()
--     local active_unit = GetPlayerActiveUnit()
--     if active_unit then
--         CameraFollowUnit(active_unit)
--     end
-- end

-- -- Override function to track unit movement
-- function AddToCameraTrackingBehavior(unit, args)
--     if g_AIExecutionController and unit then
--         if args.fallbackMove then
--             local willReveal = RevealUnitBeforeMove(unit, args)
--             if willReveal and not g_AITurnContours[unit.handle] then
--                 local enemy = unit.team.side == "enemy1" or unit.team.side == "enemy2" or unit.team.side == "neutralEnemy"
--                 g_AITurnContours[unit.handle] = SpawnUnitContour(unit, enemy and "CombatEnemy" or "CombatAlly")
--                 ShowBadgeOfAttacker(unit, true)
--                 g_AIExecutionController.fallbackMoveTracking = true
--                 args.trackMove = true
--             end
--         end
--         if args.trackMove then
--             g_AIExecutionController.tracked_pois = g_AIExecutionController.tracked_pois or {}
--             table.insert(g_AIExecutionController.tracked_pois, unit)
--             return args.fallbackMove, true
--         end
--     end
-- end

-- -- Function to control camera behavior during battle
-- function ControlCameraDuringBattle()
--     if camera_lock_on_first_unit and first_unit_id then
--         local unit = GetUnitById(first_unit_id)
--         if unit then
--             CameraFollowUnit(unit)
--         end
--     elseif camera_track_active_unit then
--         local active_unit = GetPlayerActiveUnit()
--         if active_unit then
--             CameraFollowUnit(active_unit)
--         end
--     end
-- end

-- -- Hook into existing game events to apply camera control
-- function OnMsg.NewGame()
--     SetZoomRange(0.5, 3.0)  -- Example zoom range
-- end

-- function OnMsg.CombatStarted()
--     PreventCameraChangeDuringBattle(true)
-- end

-- function OnMsg.CombatEnded()
--     PreventCameraChangeDuringBattle(false)
-- end

-- function OnMsg.UnitMovementDone(unit, action_id)
--     ControlCameraDuringBattle()
-- end

-- -- Keybindings for new functionality (example keys, customize as needed)
-- function OnMsg.KeyDown(key)
--     if key == "L" then  -- Lock/Unlock camera on first unit
--         LockCameraOnFirstUnit(not camera_lock_on_first_unit)
--     elseif key == "T" then  -- Track active unit
--         TrackActiveUnit(not camera_track_active_unit)
--     elseif key == "R" then  -- Return camera to active unit
--         ReturnCameraToActiveUnit()
--     end
-- end

-- -- Additional functions from Script2.lua to handle AI behavior
-- function RevealUnitBeforeMove(unit, args)
--     local goto_pos = args.goto_pos
--     local goto_stance = StancesList.Standing
--     local step_pos_duplicated_arr = {}
--     local pov_team = GetPoVTeam()
--     for i = 1, #pov_team.units do
--         table.insert(step_pos_duplicated_arr, goto_pos)
--     end
--     local los_any, result = CheckLOS(step_pos_duplicated_arr, pov_team.units)
--     if los_any then
--         for pi, pu in ipairs(pov_team.units) do
--             if (result[pi] == 2 or result[pi] == 1 and goto_stance == StancesList.Standing) and pu:GetDist(goto_pos) <= pu:GetSightRadius(unit, nil, goto_pos) then
--                 NetSyncEvent("RevealToTeam", unit, table.find(g_Teams, pov_team))
--                 return true
--             end
--         end
--     end
-- end

-- function OnMsg.UnitMovementDone(unit, action_id)
--     if g_AIExecutionController and action_id == "Move" and g_AIExecutionController.fallbackMoveTracking then
--         g_AIExecutionController.tracked_pois = nil
--         g_AIExecutionController.group_to_follow = nil
--         g_AIExecutionController.track_group = nil
--         g_AIExecutionController.fallbackMoveTracking = nil
--         ClearAITurnContours(unit)
--         ShowBadgeOfAttacker(unit, false)
--     end
-- end

--
--function CameraFollowObject:FollowObject()
--	if self == CameraFollowObj or not IsValid(self) then
--		UIUnfollowObj(self)
--	else
--		local bbox = self:GetObjectBBox()
--		UIFollowObj(self, nil, {
--			CameraVerticalOffset = bbox:sizez() + 20 * guic,
--			CameraHorizontalOffset = bbox:Radius2D() + 200 * guic,
--			CameraZoom = 100,
--		})
--	end
--end
--
--config.FollowCameraMaxZoom = Max(config.FollowCameraMaxZoom, 300)