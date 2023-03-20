local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "mascara",
    function (_, stats)
        stats.FireRate = 50
        stats.Damage = 7
    end
)