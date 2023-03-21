local TearEffect = require("monster_manual_scripts.TearEffect")
local Constants = require("monster_manual_scripts.Constants")


TearEffect.AddTearEffect(
    Constants.TearEffects.HOLY_LIGHT,
    function (_, tear, stats, rng)
        local baseChance = 15 + stats.Luck * 3
        if rng:RandomInt(100) < baseChance then
            tear:AddTearFlags(TearFlags.TEAR_LIGHT_FROM_HEAVEN)
        end
    end,
    function (familiar, laser, stats)
        print("lol")
    end
)