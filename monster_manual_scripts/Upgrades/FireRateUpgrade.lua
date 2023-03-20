local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewRepeatableFamiliarUpgrade(
    "tearsup",
    function (_, stats)
        stats.FireRate = stats.FireRate - 3
    end
)