---@diagnostic disable: duplicate-set-field
local familiarGenerationRNG = nil


function TSIL.Familiars.CheckFamiliar(player, collectibleType, targetCount, familiarVariant, familiarSubtype)
    if not familiarGenerationRNG then
        familiarGenerationRNG = TSIL.RNG.NewRNG()
    end

    familiarGenerationRNG:Next()

    local itemConfigItem = Isaac.GetItemConfig():GetCollectible(collectibleType)

    player:CheckFamiliar(familiarVariant, targetCount, familiarGenerationRNG, itemConfigItem, familiarSubtype)
end


