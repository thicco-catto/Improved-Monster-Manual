local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewRepeatableFamiliarUpgrade(
    "tearsup",
    function (_, stats)
        local tearsUp = math.ceil(stats.FireRate * 0.1)
        stats.FireRate = stats.FireRate - tearsUp
    end
)