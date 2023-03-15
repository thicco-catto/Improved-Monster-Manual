local TearEffect = {}

---@type TearEffectData[]
local TearEffects = {}


---@param tearEffect TearEffects
---@param onTear fun(familiar: EntityFamiliar, tear: EntityTear, stats: MonsterManualStats)
---@param onLaser fun(familiar: EntityFamiliar, laser: EntityLaser, stats: MonsterManualStats)
function TearEffect.AddTearEffect(tearEffect, onTear, onLaser)
    TearEffects[#TearEffects+1] = {
        tearEffect = tearEffect,
        onTear = onTear,
        onLaser = onLaser
    }
end


---@param familiar EntityFamiliar
---@param tear EntityTear
---@param stats MonsterManualStats
function TearEffect.TriggerTearEffect(familiar, tear, stats)
    local activeTearEffects = TSIL.Utils.Tables.Filter(TearEffects, function (_, tearEffectData)
        return TSIL.Utils.Flags.HasFlags(stats.TearEffects, tearEffectData.tearEffect)
    end)

    TSIL.Utils.Tables.ForEach(activeTearEffects, function (_, tearEffectData)
        tearEffectData.onTear(familiar, tear, stats)
    end)
end


---@param familiar EntityFamiliar
---@param laser EntityLaser
---@param stats MonsterManualStats
function TearEffect.TriggerLaserEffects(familiar, laser, stats)
    local activeTearEffects = TSIL.Utils.Tables.Filter(TearEffects, function (_, tearEffectData)
        return TSIL.Utils.Flags.HasFlags(stats.TearEffects, tearEffectData.tearEffect)
    end)

    TSIL.Utils.Tables.ForEach(activeTearEffects, function (_, tearEffectData)
        tearEffectData.onLaser(familiar, laser, stats)
    end)
end


return TearEffect