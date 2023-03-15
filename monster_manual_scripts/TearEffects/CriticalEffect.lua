local TearEffect = require("monster_manual_scripts.TearEffect")
local Constants = require("monster_manual_scripts.Constants")


TearEffect.AddTearEffect(
    Constants.TearEffects.CRITICAL,
    function (_, tear, stats)
        local rng = TSIL.RNG.NewRNG(tear.InitSeed)

        local baseChance = 25 + stats.Luck * 5
        if rng:RandomInt(100) < baseChance then
            tear.CollisionDamage = tear.CollisionDamage * 2
        end
    end,
    function (familiar, laser, stats)
        print("lol")
    end
)