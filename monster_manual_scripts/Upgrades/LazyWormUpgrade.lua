local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "lazyworm",
    false,
    function (_, stats)
        stats.ShotSpeed = stats.ShotSpeed - 0.5
        stats.FallingAccel = stats.FallingAccel - 0.02
    end
)