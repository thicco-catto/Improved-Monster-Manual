local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewRepeatableFamiliarUpgrade(
    "firerate",
    function (stats)
        stats.FireRate = stats.FireRate - 3
    end
)