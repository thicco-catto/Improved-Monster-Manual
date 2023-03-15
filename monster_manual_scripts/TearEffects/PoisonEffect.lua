local TearEffect = require("monster_manual_scripts.TearEffect")
local Constants = require("monster_manual_scripts.Constants")


TearEffect.AddTearEffect(
    Constants.TearEffects.POISON,
    function (_, tear, stats)
        local rng = TSIL.RNG.NewRNG(tear.InitSeed)

        local baseChance = 25 + stats.Luck * 5
        if rng:RandomInt(100) < baseChance then
            tear:AddTearFlags(TearFlags.TEAR_POISON)
        end
    end,
    function (familiar, laser, stats)
        print("lol")
    end
)