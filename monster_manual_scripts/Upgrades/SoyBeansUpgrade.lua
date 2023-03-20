local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "soybeans",
    function (_, stats)
        stats.FireRate = 5
        stats.Damage = 0.5
    end
)