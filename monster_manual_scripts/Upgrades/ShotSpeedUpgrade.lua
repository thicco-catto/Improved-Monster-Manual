local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewRepeatableFamiliarUpgrade(
    "shotspeedup",
    function (stats)
        stats.ShotSpeed = stats.ShotSpeed + 0.2
    end
)