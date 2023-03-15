local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewRepeatableFamiliarUpgrade(
    "shotspeed",
    function (stats)
        stats.ShotSpeed = stats.ShotSpeed + 0.2
    end
)