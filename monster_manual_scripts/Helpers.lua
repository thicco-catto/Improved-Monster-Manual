local Helpers = {}

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

return Helpers