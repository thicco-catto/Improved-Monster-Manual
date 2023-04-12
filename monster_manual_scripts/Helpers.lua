local Helpers = {}
local Constants = require("monster_manual_scripts.Constants")

local tempPlayerData = {}

---Gets some temporary player data.
---
---Temporary player data gets removed when entering a new room or
---when exiting the game
---@param player EntityPlayer
---@param field string
---@return unknown?
function Helpers.GetTemporaryPlayerData(player, field)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local playerData = tempPlayerData[playerIndex]
    if not playerData then
        playerData = {}
        tempPlayerData[playerIndex] = playerData
    end
    return playerData[field]
end

---Sets some temporary player data.
---
---Temporary player data gets removed when entering a new room or
---when exiting the game
---@param player EntityPlayer
---@param field string
---@param value unknown
function Helpers.SetTemporaryPlayerData(player, field, value)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local playerData = tempPlayerData[playerIndex]
    if not playerData then
        playerData = {}
        tempPlayerData[playerIndex] = playerData
    end
    playerData[field] = value
end

local function OnNewRoom()
    tempPlayerData = {}
end
ImprovedMonsterManualMod:AddPriorityCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    CallbackPriority.IMPORTANT,
    OnNewRoom
)


---@param familiar EntityFamiliar
---@return MonsterManualStats
function Helpers.GetFamiliarStats(familiar)
    local permanentFamiliarStats = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PERMANENT_FAMILIAR_STATS
    )

    ---@type MonsterManualStats
    local familiarStats = permanentFamiliarStats[familiar.InitSeed]

    if not familiarStats then
        local player = familiar.Player
        local playerIndex = TSIL.Players.GetPlayerIndex(player)

        local familiarStatsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            ImprovedMonsterManualMod,
            Constants.SaveKeys.PLAYERS_FAMILIAR_STATS
        )

        familiarStats = familiarStatsPerPlayer[playerIndex]
    end

    return familiarStats
end


---@param familiar EntityFamiliar
---@return boolean
function Helpers.IsFamiliarPermanent(familiar)
    local permanentFamiliarStats = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PLAYERS_FAMILIAR_STATS
    )

    ---@type MonsterManualStats
    local familiarStats = permanentFamiliarStats[familiar.InitSeed]

    return familiarStats ~= nil
end


---@param player EntityPlayer
function Helpers.GetAllNonPermanentFamiliars(player)
    local permanentFamiliars = TSIL.SaveManager.GetPersistentVariable(
        ImprovedMonsterManualMod,
        Constants.SaveKeys.PERMANENT_FAMILIAR_STATS
    )

    local familiars = TSIL.Familiars.GetPlayerFamiliars(player)
    familiars = TSIL.Utils.Tables.Filter(familiars, function (_, familiar)
        return familiar.Variant == Constants.FamiliarVariant.MONSTER_MANUAL_FAMILIAR and
            not permanentFamiliars[familiar.InitSeed]
    end)

    return familiars
end

return Helpers