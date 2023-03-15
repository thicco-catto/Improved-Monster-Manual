local TearEffect = require("monster_manual_scripts.TearEffect")
local Constants = require("monster_manual_scripts.Constants")


TearEffect.AddTearEffect(
    Constants.TearEffects.FREEZING,
    function (_, tear, stats)
        local rng = TSIL.RNG.NewRNG(tear.InitSeed)

        local baseChance = 15 + stats.Luck * 3
        if rng:RandomInt(100) < baseChance then
            tear:AddTearFlags(TearFlags.TEAR_FREEZE)
            tear:ChangeVariant(TearVariant.ICE)
        end
    end,
    function (familiar, laser, stats)
        print("lol")
    end
)