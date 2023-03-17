local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewRepeatableFamiliarUpgrade(
    "damageup",
    function (stats)
        stats.Damage = stats.Damage + 0.5
    end
)