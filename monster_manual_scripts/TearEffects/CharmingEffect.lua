local TearEffect = require("monster_manual_scripts.TearEffect")
local Constants = require("monster_manual_scripts.Constants")


TearEffect.AddTearEffect(
    Constants.TearEffects.CHARM,
    function (_, tear, stats)
        local rng = TSIL.RNG.NewRNG(tear.InitSeed)

        local baseChance = 25 + stats.Luck * 5
        if rng:RandomInt(100) < baseChance then
            tear:AddTearFlags(TearFlags.TEAR_CHARM)
            tear.Color = Color(1, 0, 1, 1, 0.2)
        end
    end,
    function (familiar, laser, stats)
        laser:AddTearFlags(TearFlags.TEAR_CHARM)
    end
)