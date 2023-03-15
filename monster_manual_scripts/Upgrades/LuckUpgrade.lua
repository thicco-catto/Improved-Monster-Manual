local FamiliarUpgrade = require("monster_manual_scripts.FamiliarUpgrade")

FamiliarUpgrade.NewRepeatableFamiliarUpgrade(
    "luck",
    function (stats)
        stats.Luck = stats.Luck + 1
    end
)