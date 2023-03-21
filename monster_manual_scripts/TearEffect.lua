local TearEffect = {}

---@type TearEffectData[]
local TearEffects = {}


---@param tearEffect TearEffects
---@param onTear fun(familiar: EntityFamiliar, tear: EntityTear, stats: MonsterManualStats, rng: RNG)
---@param onLaser fun(familiar: EntityFamiliar, laser: EntityLaser, stats: MonsterManualStats, rng: RNG)
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
---@param rng RNG
function TearEffect.TriggerTearEffect(familiar, tear, stats, rng)
    local activeTearEffects = TSIL.Utils.Tables.Filter(TearEffects, function (_, tearEffectData)
        return TSIL.Utils.Flags.HasFlags(stats.TearEffects, tearEffectData.tearEffect)
    end)

    TSIL.Utils.Tables.ForEach(activeTearEffects, function (_, tearEffectData)
        tearEffectData.onTear(familiar, tear, stats, rng)
    end)
end


---@param familiar EntityFamiliar
---@param laser EntityLaser
---@param stats MonsterManualStats
---@param rng RNG
function TearEffect.TriggerLaserEffects(familiar, laser, stats, rng)
    local activeTearEffects = TSIL.Utils.Tables.Filter(TearEffects, function (_, tearEffectData)
        return TSIL.Utils.Flags.HasFlags(stats.TearEffects, tearEffectData.tearEffect)
    end)

    TSIL.Utils.Tables.ForEach(activeTearEffects, function (_, tearEffectData)
        tearEffectData.onLaser(familiar, laser, stats, rng)
    end)
end


return TearEffect