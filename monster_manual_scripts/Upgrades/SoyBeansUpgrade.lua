local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewBlueFamiliarUpgrade(
    "soybeans",
    true,
    function (_, stats)
        stats.FireRate = math.ceil(stats.FireRate * 0.3)
        stats.Damage = 0.5
    end
)