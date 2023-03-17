local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewRepeatableFamiliarUpgrade(
    "luckup",
    function (stats)
        stats.Luck = stats.Luck + 1
    end
)