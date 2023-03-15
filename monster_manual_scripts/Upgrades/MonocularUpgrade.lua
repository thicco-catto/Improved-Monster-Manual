local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "monocular",
    function (stats)
        stats.FireRate = 50
        stats.Damage = 7
    end
)