local TearEffect = require("monster_manual_scripts.TearEffect")
local Constants = require("monster_manual_scripts.Constants")


TearEffect.AddTearEffect(
    Constants.TearEffects.CRITICAL,
    function (_, tear, stats, rng)
        local rng = TSIL.RNG.NewRNG(tear.InitSeed)

        local baseChance = 30 + stats.Luck * 6
        if rng:RandomInt(100) < baseChance then
            tear.CollisionDamage = tear.CollisionDamage * 2
            tear.Color = Color(0.9, 0.2, 0.2)
        end
    end,
    function (_, laser, stats, rng)
        local baseChance = 30 + stats.Luck * 6
        if rng:RandomInt(100) < baseChance then
            laser.CollisionDamage = laser.CollisionDamage * 2
        end
    end
)