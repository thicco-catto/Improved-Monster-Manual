local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "lazyworm",
    function (_, stats)
        stats.ShotSpeed = stats.ShotSpeed - 0.5
    end
)