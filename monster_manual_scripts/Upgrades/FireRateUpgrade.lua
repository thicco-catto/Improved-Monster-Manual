local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewRepeatableFamiliarUpgrade(
    "tearsup",
    function (stats)
        stats.FireRate = stats.FireRate - 3
    end
)