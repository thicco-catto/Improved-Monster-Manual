local TearEffect = require("monster_manual_scripts.TearEffect")
local Constants = require("monster_manual_scripts.Constants")


TearEffect.AddTearEffect(
    Constants.TearEffects.POISON,
    function (_, tear, stats, rng)
        local baseChance = 25 + stats.Luck * 5
        if rng:RandomInt(100) < baseChance then
            tear:AddTearFlags(TearFlags.TEAR_POISON)
            tear.Color = Color(0.5, 0.9, 0.4)
        end
    end,
    function (_, laser, stats, rng)
        local baseChance = 25 + stats.Luck * 5
        if rng:RandomInt(100) < baseChance then
            laser:AddTearFlags(TearFlags.TEAR_POISON)
            laser.Color = Color(0.5, 0.9, 0.4)
        end
    end
)