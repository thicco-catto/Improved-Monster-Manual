---@diagnostic disable: duplicate-set-field
function TSIL.Familiars.GetPlayerFamiliars(player)
    local playerPtrHash = GetPtrHash(player)
    local familiars = TSIL.EntitySpecific.GetFamiliars()

    return TSIL.Utils.Tables.Filter(familiars, function (_, familiar)
        local familiarPlayerPtrHash = GetPtrHash(familiar.Player)
        return playerPtrHash == familiarPlayerPtrHash
    end)
end
