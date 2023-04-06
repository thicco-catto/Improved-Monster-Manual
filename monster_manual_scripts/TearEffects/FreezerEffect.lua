local TearEffect = require("monster_manual_scripts.TearEffect")
local Constants = require("monster_manual_scripts.Constants")


TearEffect.AddTearEffect(
    Constants.TearEffects.FREEZING,
    function (_, tear, stats, rng)
        local baseChance = 15 + stats.Luck * 3
        if rng:RandomInt(100) < baseChance then
            tear:AddTearFlags(TearFlags.TEAR_FREEZE)
            tear:ChangeVariant(TearVariant.ICE)
        end
    end,
    function (_, laser, stats, rng)
        local baseChance = 15 + stats.Luck * 3
        if rng:RandomInt(100) < baseChance then
            laser:AddTearFlags(TearFlags.TEAR_FREEZE)
        end
    end
)