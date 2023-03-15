local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "soybeans",
    function (stats)
        stats.FireRate = 1
        stats.Damage = 0.5
    end
)