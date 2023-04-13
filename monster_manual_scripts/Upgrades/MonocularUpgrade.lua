local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "mascara",
    true,
    function (_, stats)
        stats.FireRate = stats.FireRate + 30
        stats.Damage = stats.Damage + 10
    end
)