ImprovedMonsterManualMod = RegisterMod("ImprovedMonsterManualMod", 1)

local myFolder = "monster_manual_loi"
local LOCAL_TSIL = require(myFolder .. ".TSIL")
LOCAL_TSIL.Init(myFolder)


---@param player EntityPlayer
function ImprovedMonsterManualMod:PreMonsterManualUse(_, _, player)
    return true
end
ImprovedMonsterManualMod:AddCallback(
    ModCallbacks.MC_PRE_USE_ITEM,
    ImprovedMonsterManualMod.PreMonsterManualUse,
    CollectibleType.COLLECTIBLE_MONSTER_MANUAL
)