local TearEffect = require("monster_manual_scripts.TearEffect")
local Constants = require("monster_manual_scripts.Constants")


TearEffect.AddTearEffect(
    Constants.TearEffects.FEAR,
    function (_, tear, stats, rng)
        local baseChance = 25 + stats.Luck * 5
        if rng:RandomInt(100) < baseChance then
            tear:AddTearFlags(TearFlags.TEAR_FEAR)
            tear:ChangeVariant(TearVariant.DARK_MATTER)
        end
    end,
    function (_, laser)
        laser:AddTearFlags(TearFlags.TEAR_FEAR)
    end
)