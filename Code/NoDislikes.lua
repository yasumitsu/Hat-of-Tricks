function OnMsg.UnitCreated(unit)
    if not IsMerc(unit) then 
        return
    end
     -- This function removes all dislike relationships between mercs
    if CurrentModOptions["NoDislikes"] == true then
        print("Removing all dislikes for", unit.unitdatadef_id)
        
        -- Clear the Dislikes table for the current unit
        unit.Dislikes = {}
        
        -- Remove this unit from other mercs' Dislikes tables
        for _, mercData in pairs(gv_UnitData) do
            if mercData.Dislikes then
                local updatedDislikes = {}
                for _, dislikedMerc in ipairs(mercData.Dislikes) do
                    if dislikedMerc ~= unit.unitdatadef_id then
                        table.insert(updatedDislikes, dislikedMerc)
                    end
                end
                mercData.Dislikes = updatedDislikes
            end
        end
        
        print("All dislikes removed for", unit.unitdatadef_id)
    end
        
end