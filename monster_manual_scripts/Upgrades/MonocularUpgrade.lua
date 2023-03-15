local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "soybeans",
    function (stats)
        stats.FireRate = 50
        stats.Damage = 7
    end
)