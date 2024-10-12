-- This function makes all mercs learn to like each other

function OnMsg.UnitCreated(unit)
    if not IsMerc(unit) then 
        return
    end
    if CurrentModOptions["AllLearnToLike"] == true then
    
        print("Making all mercs learn to like each other, including", unit.unitdatadef_id)
        
        -- Add all existing mercs to the new unit's LearnToLike table
        unit.LearnToLike = {}
        for mercId, mercData in pairs(gv_UnitData) do
            if mercId ~= unit.unitdatadef_id then
                table.insert(unit.LearnToLike, mercId)
            end
        end
        -- Add the new unit to all other mercs' LearnToLike tables
        for _, mercData in pairs(gv_UnitData) do
            if not mercData.LearnToLike then
                mercData.LearnToLike = {}
            end
            table.insert_unique(mercData.LearnToLike, unit.unitdatadef_id)
        end
        print("All mercs now learn to like each other, including", unit.unitdatadef_id)
    end
end
    